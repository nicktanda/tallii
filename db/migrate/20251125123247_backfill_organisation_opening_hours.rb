class BackfillOrganisationOpeningHours < ActiveRecord::Migration[8.0]
  DEFAULT_OPENING_HOURS = {
    "Monday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Tuesday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Wednesday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Thursday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Friday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Saturday" => { "open" => "09:00", "close" => "17:00", "closed" => "true" },
    "Sunday" => { "open" => "09:00", "close" => "17:00", "closed" => "true" }
  }.freeze

  def up
    Organisation.find_each do |org|
      raw_hours = org.opening_hours
      current_hours = case raw_hours
                      when String then JSON.parse(raw_hours) rescue {}
                      when Hash then raw_hours
                      else {}
                      end

      # Deep merge: fill in missing days AND missing keys within each day
      updated_hours = DEFAULT_OPENING_HOURS.each_with_object({}) do |(day, defaults), result|
        existing_day = current_hours[day] || {}
        existing_day = JSON.parse(existing_day) if existing_day.is_a?(String)
        result[day] = defaults.merge(existing_day)
      end

      org.update_column(:opening_hours, updated_hours.to_json)
    end
  end

  def down
    # No-op: we don't want to remove opening hours
  end
end
