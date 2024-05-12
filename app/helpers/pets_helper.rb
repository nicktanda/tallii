module PetsHelper
  def last_uploaded_image_date(pet)
    return if pet.images.empty?
      
    pet.images.last.created_at.strftime('%d %b %Y')
  end
end