class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user, :published, :created_at

  def user
    object.user.email
  end

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
