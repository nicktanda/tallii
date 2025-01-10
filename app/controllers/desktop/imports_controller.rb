module Desktop
  class ImportsController < DesktopController
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
        user = current_organisation.users.new(first_name: row[0], last_name: row[1], email: row[2], password: row[3], phone: row[4])
        
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
      notice += "Failed to import employees: #{error_messages.join(', ')}" if error_messages.any?

      redirect_to desktop_users_new_path, alert: notice
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
        user = current_organisation.users.new(first_name: row[0], last_name: row[1], email: row[2], password: row[3], phone: row[4])
        
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
      notice += "Failed to import employees: #{error_messages.join(', ')}" if error_messages.any?

      redirect_to desktop_users_new_path, alert: notice
    end
  end
end