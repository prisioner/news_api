class Article < ApplicationRecord
  belongs_to :user

  validates :title, :anounce, :body, presence: true
end
