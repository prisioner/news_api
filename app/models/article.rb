class Article < ApplicationRecord
  belongs_to :user
  has_many :favorite_articles, dependent: :destroy

  validates :title, :anounce, :body, presence: true
end
