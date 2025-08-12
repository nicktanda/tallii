require 'rails_helper'

RSpec.describe PetsHelper, type: :helper do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisation: organisation) }
  let(:pet) { create(:pet, user: user) }

  describe '#last_uploaded_image_date' do
    context 'when pet has no images' do
      it 'returns nil' do
        expect(helper.last_uploaded_image_date(pet)).to be_nil
      end
    end

    context 'when pet has images' do
      let!(:image1) { create(:image, user: user) }
      let!(:image2) { create(:image, user: user) }

      before do
        # Mock the pet.images association
        allow(pet).to receive(:images).and_return([image1, image2])
        allow(pet.images).to receive(:empty?).and_return(false)
        allow(pet.images).to receive(:last).and_return(image2)

        # Set a specific creation time for testing
        image2.created_at = Time.parse('2024-03-15 10:30:00')
      end

      it 'returns the formatted date of the last image' do
        result = helper.last_uploaded_image_date(pet)
        expect(result).to eq('15 Mar 2024')
      end

      it 'formats the date correctly' do
        # Test with different date
        image2.created_at = Time.parse('2023-12-01 15:45:30')
        result = helper.last_uploaded_image_date(pet)
        expect(result).to eq('01 Dec 2023')
      end
    end

    context 'when pet has single image' do
      let!(:single_image) { create(:image, user: user) }

      before do
        allow(pet).to receive(:images).and_return([single_image])
        allow(pet.images).to receive(:empty?).and_return(false)
        allow(pet.images).to receive(:last).and_return(single_image)
        single_image.created_at = Time.zone.parse('2024-01-01 00:00:00')
      end

      it 'returns the formatted date of the single image' do
        result = helper.last_uploaded_image_date(pet)
        expect(result).to eq('01 Jan 2024')
      end
    end
  end
end