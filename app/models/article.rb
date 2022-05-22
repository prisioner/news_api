class Article < ApplicationRecord
  belongs_to :user
  has_many :favorite_articles, dependent: :destroy
  has_many :viewed_articles, dependent: :destroy

  validates :title, :anounce, :body, presence: true

  scope :unread_by, -> (user) {
    left_outer_joins(:viewed_articles).
      where("viewed_articles.user_id IS NULL
        OR viewed_articles.user_id != ?", user.id)
  }
end
