class Article < ApplicationRecord
  validates :title, :anounce, :body, presence: true
end
