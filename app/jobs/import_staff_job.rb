class ImportStaffJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    import = Import.find(import_id)
    import.processing!

    organisation = import.organisation
    error_messages = []
    users_found = 0
    users_created = 0

    begin
      rows = parse_import_file(import)
      import.update!(total: rows.count)

      rows.each_with_index do |row, index|
        first_name = row[0].to_s.strip
        last_name = row[1].to_s.strip
        email = row[2].to_s.strip.downcase
        password = row[3].to_s.strip
        phone = row[4].to_s.strip.gsub(/\D/, '')
        role = row[5].to_s.strip

        if first_name.blank? || last_name.blank? || email.blank? || password.blank? || role.blank?
          error_messages << "Employee #{first_name} #{last_name}: Missing required fields."
          import.update!(progress: index + 1)
          next
        end

        unless email.match?(URI::MailTo::EMAIL_REGEXP)
          error_messages << "Employee #{first_name} #{last_name}: Invalid email format."
          import.update!(progress: index + 1)
          next
        end

        # Check if user already exists
        existing_user = organisation.users.find_by(email: email)
        if existing_user
          users_found += 1
          import.update!(
            progress: index + 1,
            users_found: users_found,
            users_created: users_created
          )
          next
        end

        begin
          user = organisation.users.new(
            first_name: first_name,
            last_name: last_name,
            email: email,
            password: password,
            phone: phone,
            role: role
          )

          if user.save
            users_created += 1
          else
            error_messages << "Employee #{first_name} #{last_name}: #{user.errors.full_messages.join(', ')}"
          end
        rescue ActiveRecord::RecordNotUnique
          users_found += 1
        rescue => e
          error_messages << "Employee #{first_name} #{last_name}: #{e.message}"
        end

        import.update!(
          progress: index + 1,
          users_found: users_found,
          users_created: users_created
        )
      end

      import.update!(
        status: :completed,
        users_found: users_found,
        users_created: users_created,
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

    rows = []
    blob.open do |tempfile|
      CSV.foreach(tempfile.path, col_sep: ',') do |row|
        rows << row
      end
    end
    rows
  end
end
