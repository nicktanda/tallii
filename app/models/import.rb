class Import < ApplicationRecord
  belongs_to :user
  belongs_to :organisation

  has_one_attached :file

  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  def progress_percentage
    return 0 if total.zero?
    ((progress.to_f / total) * 100).round
  end

  def parsed_error_messages
    return [] if error_messages.blank?
    JSON.parse(error_messages)
  rescue JSON::ParserError
    []
  end
end
