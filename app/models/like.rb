class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :iser_id, uniqueness: {scope: :post_id}
end
