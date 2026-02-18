module Desktop
  class ImportsController < DesktopController
    def import; end

    def example_staff_csv
      file_path = Rails.root.join('public', 'Talii User Import - Staff.csv')
      if File.exist?(file_path)
        send_file file_path, type: 'text/csv', disposition: 'attachment', filename: 'Talii User Import - Staff.csv'
      else
        redirect_to root_path, alert: 'File not found.'
      end
    end

    def import_staff
      return render json: { error: 'No file added' }, status: :unprocessable_entity if params[:file].nil?
      return render json: { error: 'Only CSV files allowed' }, status: :unprocessable_entity unless params[:file].content_type == 'text/csv'

      import = Import.create!(
        user: current_user,
        organisation: current_organisation,
        file_name: params[:file].original_filename,
        import_type: 'staff',
        status: :pending
      )

      import.file.attach(params[:file])

      ImportStaffJob.perform_later(import.id)

      render json: { import_id: import.id }
    rescue => e
      Rails.logger.error "Staff import error: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def example_combined_csv
      file_path = Rails.root.join('public', 'Talii User Import - Combined.csv')
      if File.exist?(file_path)
        send_file file_path, type: 'text/csv', disposition: 'attachment', filename: 'Talii User Import - Combined.csv'
      else
        redirect_to root_path, alert: 'File not found.'
      end
    end

    def import_combined
      Rails.logger.info "Import combined called"
      Rails.logger.info "File param: #{params[:file].inspect}"

      return render json: { error: 'No file added' }, status: :unprocessable_entity if params[:file].nil?

      Rails.logger.info "Content type: #{params[:file].content_type}"

      allowed_types = ['text/csv', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-excel']
      unless allowed_types.include?(params[:file].content_type)
        return render json: { error: "Only CSV or Excel files allowed. Got: #{params[:file].content_type}" }, status: :unprocessable_entity
      end

      import = Import.create!(
        user: current_user,
        organisation: current_organisation,
        file_name: params[:file].original_filename,
        import_type: 'combined',
        status: :pending
      )

      Rails.logger.info "Import created: #{import.id}"

      import.file.attach(params[:file])

      Rails.logger.info "File attached, queuing job"

      ImportCombinedJob.perform_later(import.id)

      render json: { import_id: import.id }
    rescue => e
      Rails.logger.error "Import error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def import_progress
      import = current_organisation.imports.find(params[:id])

      render json: {
        status: import.status,
        progress: import.progress,
        total: import.total,
        progress_percentage: import.progress_percentage,
        users_found: import.users_found,
        users_created: import.users_created,
        pets_skipped: import.pets_skipped,
        pets_created: import.pets_created,
        rows_skipped: import.rows_skipped,
        error_messages: import.parsed_error_messages
      }
    end
  end
end
