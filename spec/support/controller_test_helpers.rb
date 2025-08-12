module ControllerTestHelpers
  # Helper method to simulate user authentication for controllers
  def sign_in_user(user)
    session["user"] = { "id" => user.id }
  end

  # Helper method to set current pet for tests
  def set_current_pet(pet)
    session["current_pet"] = pet.id
  end

  # Helper method to sign out user
  def sign_out
    session.clear
  end

  # Helper method to create valid session for employee app
  def sign_in_employee(employee)
    session["user"] = { "id" => employee.id }
  end

  # Helper method to simulate desktop user login
  def sign_in_desktop_user(user)
    session["user"] = { "id" => user.id }
  end


  # Helper method to create valid file upload for tests
  def valid_image_upload
    fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpeg')
  end

  # Helper method to create test file attachment
  def create_test_image
    Rack::Test::UploadedFile.new('spec/fixtures/test_image.jpg', 'image/jpeg')
  end
end