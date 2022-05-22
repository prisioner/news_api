class ArticleQuery
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @author_id = Integer(params[:author_id].presence, exception: false)
    @scope = Article.all
  end

  def call
    @scope = @scope.where(user_id: @author_id) if @author_id

    @scope
  end
end
