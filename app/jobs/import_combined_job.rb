class ImportCombinedJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    import = Import.find(import_id)
    import.processing!

    organisation = import.organisation
    error_messages = []
    users_found = 0
    users_created = 0
    pets_skipped = 0
    pets_created = 0
    rows_empty = 0
    rows_no_user = 0

    begin
      rows = parse_import_file(import)
      import.update!(total: rows.count)

      rows.each_with_index do |row, index|
        first_name = row['first_name'].to_s.strip
        last_name = row['last_name'].to_s.strip
        email = row['email'].to_s.strip.downcase
        phone = row['phone_1'].to_s.strip.gsub(/\D/, '')
        pets_data = row['pets'].to_s.strip

        if first_name.blank? && last_name.blank? && email.blank? && phone.blank?
          rows_empty += 1
          import.update!(progress: index + 1)
          next
        end

        if email.present? && !email.match?(URI::MailTo::EMAIL_REGEXP)
          error_messages << "Row for #{first_name} #{last_name}: Invalid email format."
          import.update!(progress: index + 1)
          next
        end

        begin
          user, was_created = find_or_create_user(organisation, first_name, last_name, email, phone)

          if user.nil?
            rows_no_user += 1
            error_messages << "Row for #{first_name} #{last_name}: No valid email to create user and no existing user found by phone."
            import.update!(progress: index + 1)
            next
          end

          if was_created
            users_created += 1
          else
            users_found += 1
          end

          if pets_data.present?
            pet_entries = pets_data.split(',').map(&:strip).reject(&:blank?)
            pet_entries.each do |pet_entry|
              pet_name, breed = parse_pet_entry(pet_entry)
              if user.pets.exists?(name: pet_name)
                pets_skipped += 1
              else
                pet = user.pets.new(
                  name: pet_name,
                  breed: breed,
                  dob: Date.new(2020, 1, 1),
                  health_conditions: 'Unknown',
                  weight: 0,
                  species: :dog,
                  gender: :male
                )
                if pet.save
                  pets_created += 1
                else
                  error_messages << "Pet '#{pet_name}' for #{first_name} #{last_name}: #{pet.errors.full_messages.join(', ')}"
                end
              end
            end
          end
        rescue ActiveRecord::RecordInvalid => e
          error_messages << "Row for #{first_name} #{last_name}: #{e.message}"
        rescue => e
          error_messages << "Row for #{first_name} #{last_name}: #{e.message}"
        end

        import.update!(
          progress: index + 1,
          users_found: users_found,
          users_created: users_created,
          pets_skipped: pets_skipped,
          pets_created: pets_created
        )
      end

      rows_skipped = rows_empty + rows_no_user

      import.update!(
        status: :completed,
        users_found: users_found,
        users_created: users_created,
        pets_skipped: pets_skipped,
        pets_created: pets_created,
        rows_skipped: rows_skipped,
        error_messages: error_messages.to_json
      )
    rescue => e
      import.update!(
        status: :failed,
        error_messages: [e.message].to_json
      )
    end
  end

  private

  def parse_import_file(import)
    blob = import.file
    extension = File.extname(import.file_name).downcase

    blob.open do |tempfile|
      if extension == '.csv'
        parse_csv_file(tempfile.path)
      else
        parse_excel_file(tempfile.path)
      end
    end
  end

  def parse_csv_file(file_path)
    content = File.read(file_path)
    delimiter = detect_csv_delimiter(content)

    rows = []
    CSV.foreach(file_path, col_sep: delimiter, headers: true) do |row|
      rows << row.to_h
    end
    rows
  end

  def detect_csv_delimiter(content)
    first_line = content.lines.first.to_s
    tab_count = first_line.count("\t")
    comma_count = first_line.count(',')

    tab_count > comma_count ? "\t" : ','
  end

  def parse_excel_file(file_path)
    spreadsheet = Roo::Spreadsheet.open(file_path)
    headers = spreadsheet.row(1).map(&:to_s)

    rows = []
    (2..spreadsheet.last_row).each do |i|
      row_data = spreadsheet.row(i)
      row_hash = headers.zip(row_data.map(&:to_s)).to_h
      rows << row_hash
    end
    rows
  end

  def parse_pet_entry(entry)
    if entry =~ /^(.+?)\s*\((.+?)\)\s*$/
      name = $1.strip
      breed = $2.strip
    else
      name = entry.strip
      breed = 'Unknown'
    end
    [name, breed]
  end

  def find_or_create_user(organisation, first_name, last_name, email, phone)
    user = nil
    was_created = false

    # Only search by email if it's a valid email
    if email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
      user = organisation.users.find_by(email: email)
    end

    # Try phone if no user found by email
    user ||= organisation.users.find_by(phone: phone) if phone.present?

    if user
      # Update existing user with any new info
      updates = {}
      updates[:first_name] = first_name if first_name.present? && user.first_name.blank?
      updates[:last_name] = last_name if last_name.present? && user.last_name.blank?
      updates[:email] = email if email.present? && email.match?(URI::MailTo::EMAIL_REGEXP) && user.email.blank?
      updates[:phone] = phone if phone.present? && user.phone.blank?
      user.update(updates) if updates.any?
    else
      # Only create a new user if we have a valid email
      if email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
        user = organisation.users.create!(
          first_name: first_name,
          last_name: last_name,
          email: email,
          phone: phone.presence,
          password: 'changeme123'
        )
        was_created = true
      else
        # Can't create user without valid email, return nil
        return [nil, false]
      end
    end

    [user, was_created]
  end
end
