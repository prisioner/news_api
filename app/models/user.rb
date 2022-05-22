class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist

  has_many :articles, dependent: :destroy
  has_many :favorite_articles, dependent: :destroy

  scope :authors, -> {
    joins(:articles).where(articles: { published: true }).distinct
  }
end
