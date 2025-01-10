module Desktop
  module Users
    class CustomersController < DesktopController
      require 'csv'

      before_action :users

      def index; end

      def show
        @user = users.find(params[:id])
        @bookings = @user.pets.map do |pet|
          grooms = pet.grooms.map do |groom|
            { pet: pet.name, time: groom.time, date: groom.date, status: groom.formatted_status }
          end
          daycare_visits = pet.daycare_visits.map do |daycare_visit|
            { pet: pet.name, time: daycare_visit.time, date: daycare_visit.date, status: daycare_visit.formatted_status }
          end
          (grooms + daycare_visits).sort_by {|booking| [booking[:date], booking[:time]] }
        end.flatten
      end

      def edit
        @user = users.find(params[:id])
      end

      def booking_settings
        @user = users.find(params[:id])
      end

      def new; end

      def import
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
            error_messages << "User #{row.inspect}: Missing required fields."
            next
          end

          unless email.match?(URI::MailTo::EMAIL_REGEXP)
            error_messages << "User #{first_name} #{last_name}: Invalid email format."
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

        if error_messages.empty?
          redirect_to desktop_users_new_path, notice: "#{user_count} users imported successfully"
        else
          redirect_to desktop_users_new_path, alert: "Failed to import users: #{error_messages.join(', ')}"
        end
      end

      private

      def users
        @users ||= current_organisation.users.customers
      end
    end
  end
end