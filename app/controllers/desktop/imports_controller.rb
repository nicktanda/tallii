module Desktop
  class ImportsController < DesktopController
    def import; end

    def example_customer_csv
      file_path = Rails.root.join('public', 'Talii User Import - Customers.csv')
      if File.exist?(file_path)
        send_file file_path, type: 'text/csv', disposition: 'attachment', filename: 'Talii User Import - Customers.csv'
      else
        redirect_to root_path, alert: 'File not found.'
      end
    end

    def example_staff_csv
      file_path = Rails.root.join('public', 'Talii User Import - Staff.csv')
      if File.exist?(file_path)
        send_file file_path, type: 'text/csv', disposition: 'attachment', filename: 'Talii User Import - Staff.csv'
      else
        redirect_to root_path, alert: 'File not found.'
      end
    end

    def example_pets_csv
      file_path = Rails.root.join('public', 'Talii User Import - Pets.csv')
      if File.exist?(file_path)
        send_file file_path, type: 'text/csv', disposition: 'attachment', filename: 'Talii User Import - Pets.csv'
      else
        redirect_to root_path, alert: 'File not found.'
      end
    end

    def import_customers
      return redirect_to desktop_users_new_path, notice: 'No file added' if params[:file].nil?
      return redirect_to desktop_users_new_path, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

      opened_file = File.open(params[:file])
      options = { col_sep: ',' }

      user_count = 0
      error_messages = []

      CSV.foreach(opened_file, **options) do |row|
        first_name = row[0].to_s.strip
        last_name = row[1].to_s.strip
        email = row[2].to_s.strip.downcase
        password = row[3].to_s.strip
        phone = row[4].to_s.strip.gsub(/\D/, '')

        if first_name.blank? || last_name.blank? || email.blank? || password.blank?
          error_messages << "Customer #{row.inspect}: Missing required fields."
          next
        end

        unless email.match?(URI::MailTo::EMAIL_REGEXP)
          error_messages << "Customer #{first_name} #{last_name}: Invalid email format."
          next
        end

        user = current_organisation.users.new(
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
          phone: phone
        )
        
        begin
          if user.save
            user_count += 1
          else
            error_messages << "Row #{row.inspect}: #{user.errors.full_messages.join(', ')}"
          end
        rescue ActiveRecord::RecordNotUnique
          error_messages << "Email '#{row[2]}' already exists."
        rescue => e
          error_messages << e.message
        end
      end

      notice = "#{user_count} customers imported successfully"
      notice += ", Failed to import customers: #{error_messages.join(', ')}" if error_messages.any?

      redirect_to desktop_import_path, alert: notice
    end
    
    def import_staff
      return redirect_to desktop_users_new_path, notice: 'No file added' if params[:file].nil?
      return redirect_to desktop_users_new_path, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

      opened_file = File.open(params[:file])
      options = { col_sep: ',' }

      user_count = 0
      error_messages = []

      CSV.foreach(opened_file, **options) do |row|
        first_name = row[0].to_s.strip
        last_name = row[1].to_s.strip
        email = row[2].to_s.strip.downcase
        password = row[3].to_s.strip
        phone = row[4].to_s.strip.gsub(/\D/, '')
        role = row[5].to_s.strip

        if first_name.blank? || last_name.blank? || email.blank? || password.blank? || role.blank?
          error_messages << "Employee #{row.inspect}: Missing required fields."
          next
        end

        unless email.match?(URI::MailTo::EMAIL_REGEXP)
          error_messages << "Employee #{first_name} #{last_name}: Invalid email format."
          next
        end

        user = current_organisation.users.new(
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
          phone: phone,
          role: role
        )
        
        begin
          if user.save
            user_count += 1
          else
            error_messages << "Row #{row.inspect}: #{user.errors.full_messages.join(', ')}"
          end
        rescue ActiveRecord::RecordNotUnique
          error_messages << "Email '#{row[2]}' already exists."
        rescue => e
          error_messages << e.message
        end
      end

      notice = "#{user_count} employees imported successfully"
      notice += ", Failed to import employees: #{error_messages.join(', ')}" if error_messages.any?

      redirect_to desktop_import_path, alert: notice
    end

    def import_pets
      return redirect_to desktop_users_new_path, notice: 'No file added' if params[:file].nil?
      return redirect_to desktop_users_new_path, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

      opened_file = File.open(params[:file])
      options = { col_sep: ',' }

      pet_count = 0
      error_messages = []

      CSV.foreach(opened_file, **options) do |row|
        user_email = row[0].to_s.strip
        name = row[1].to_s.strip
        dob = Date.strptime(row[2].to_s.strip, '%d/%m/%Y')
        breed = row[3].to_s.strip
        species = row[4].to_s.strip
        gender = row[5].to_s.strip
        weight = row[6].to_s.strip
        health_conditions = row[7].to_s.strip

        if user_email.blank? || name.empty? || dob.blank? || breed.blank? || species.blank? || gender.blank? || weight.blank? || health_conditions.blank?
          error_messages << "Pet #{row.inspect}: Missing required fields."
          next
        end

        user = current_organisation.users.find_by(email: user_email)
        unless user
          error_messages << "Pet #{row[0]}: User not found."
          next
        end

        pet = current_organisation.pets.new(
          user: user, 
          name: name,
          dob: dob,
          breed: breed,
          species: species,
          gender: gender,
          weight: weight,
          health_conditions: health_conditions
        )
        
        begin
          if pet.save
            pet_count += 1
          else
            error_messages << "Row #{row.inspect}: #{pet.errors.full_messages.join(', ')}"
          end
        rescue ActiveRecord::RecordNotUnique
          error_messages << "Email '#{row[2]}' already exists."
        rescue => e
          error_messages << e.message
        end
      end

      notice = "#{pet_count} pets imported successfully"
      notice += ", Failed to import pets: #{error_messages.join(', ')}" if error_messages.any?

      redirect_to desktop_import_path, alert: notice
    end
  end
end