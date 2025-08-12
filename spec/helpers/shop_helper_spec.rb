require 'rails_helper'

RSpec.describe ShopHelper, type: :helper do
  let(:organisation) { create(:organisation) }
  let(:product) { create(:product, organisation: organisation) }

  describe '#review_summary' do
    context 'when product has no reviews' do
      it 'returns zero average and count' do
        result = helper.review_summary(product)
        
        expect(result[:average_review]).to eq(0)
        expect(result[:total_reviews]).to eq(0)
      end
    end

    context 'when product has reviews' do
      let(:user1) { create(:user, organisation: organisation) }
      let(:user2) { create(:user, organisation: organisation) }
      let(:user3) { create(:user, organisation: organisation) }

      let!(:review1) { create(:review, product: product, user: user1, rating: 5) }
      let!(:review2) { create(:review, product: product, user: user2, rating: 3) }
      let!(:review3) { create(:review, product: product, user: user3, rating: 4) }

      it 'calculates correct average rating' do
        result = helper.review_summary(product)
        
        # Average of 5, 3, 4 is 4.0
        expect(result[:average_review]).to eq(4.0)
      end

      it 'returns correct total review count' do
        result = helper.review_summary(product)
        
        expect(result[:total_reviews]).to eq(3)
      end

      it 'rounds average rating to 2 decimal places' do
        # Add a review that creates a decimal average
        user4 = create(:user, organisation: organisation)
        create(:review, product: product, user: user4, rating: 1)
        
        result = helper.review_summary(product)
        
        # Average of 5, 3, 4, 1 is 3.25
        expect(result[:average_review]).to eq(3.25)
      end

      it 'handles edge case with single review' do
        # Create a new product with single review
        single_review_product = create(:product, organisation: organisation)
        create(:review, product: single_review_product, user: user1, rating: 5)
        
        result = helper.review_summary(single_review_product)
        
        expect(result[:average_review]).to eq(5.0)
        expect(result[:total_reviews]).to eq(1)
      end
    end

    context 'when product has reviews with various ratings' do
      let(:users) { create_list(:user, 10, organisation: organisation) }

      before do
        # Create reviews with ratings 1-5, twice each (ratings: 1,1,2,2,3,3,4,4,5,5)
        ratings = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
        users.each_with_index do |user, index|
          create(:review, product: product, user: user, rating: ratings[index])
        end
      end

      it 'calculates correct average for multiple reviews' do
        result = helper.review_summary(product)
        
        # Average of [1,1,2,2,3,3,4,4,5,5] is 3.0
        expect(result[:average_review]).to eq(3.0)
        expect(result[:total_reviews]).to eq(10)
      end
    end

    context 'when average is nil (edge case)' do
      before do
        # Mock the scenario where average returns nil
        allow(product).to receive(:reviews).and_return(double(average: nil, count: 0))
      end

      it 'handles nil average gracefully' do
        result = helper.review_summary(product)
        
        expect(result[:average_review]).to eq(0)
        expect(result[:total_reviews]).to eq(0)
      end
    end

    context 'when reviews have decimal ratings (if supported)' do
      let(:user1) { create(:user, organisation: organisation) }
      let(:user2) { create(:user, organisation: organisation) }

      before do
        # Mock reviews with decimal ratings for precision testing
        allow(product).to receive(:reviews).and_return(
          double(
            average: 4.333333,
            count: 2
          )
        )
      end

      it 'rounds decimal averages to 2 decimal places' do
        result = helper.review_summary(product)
        
        expect(result[:average_review]).to eq(4.33)
        expect(result[:total_reviews]).to eq(2)
      end
    end
  end
end