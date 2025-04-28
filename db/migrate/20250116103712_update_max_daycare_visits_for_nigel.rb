class UpdateMaxDaycareVisitsForNigel < ActiveRecord::Migration[7.0]
  def change
    User.find_by(email: 'nigelhaviscon@gmail.com')&.update!(max_daycare_visits: 10)
  end
end
