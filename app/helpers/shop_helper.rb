module ShopHelper
  def review_summary(product)
    average_review = product.reviews.average(:rating).to_f.round(2)
    total_reviews = product.reviews.count

    {
      average_review: average_review || 0,
      total_reviews: total_reviews
    }
  end
end