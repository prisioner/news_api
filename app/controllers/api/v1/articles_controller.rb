class Api::V1::ArticlesController < ApplicationController
  before_action :set_article,
    only: %i[show update destroy add_favorite remove_favorite]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: %i[index unread]

  def index
    articles = policy_scope(ArticleQuery.call(params))

    render json: articles, each_serializer: ArticleCollectionSerializer
  end

  def unread
    authorize Article

    articles = policy_scope(Article.unread_by(current_user))

    render json: articles, each_serializer: ArticleCollectionSerializer
  end

  def create
    authorize Article

    article = Article.new(article_params)
    article.user = current_user

    if article.save
      ViewedArticle.create!(article: article, user: current_user)
      render json: article
    else
      render json: {errors: article.errors.full_messages}
    end
  end

  def add_favorite
    authorize @article

    FavoriteArticle
      .find_or_create_by!(user: current_user, article: @article)

    render json: {message: "Article ##{@article.id} added to favorite"}
  end

  def remove_favorite
    authorize @article

    FavoriteArticle
      .find_by(user: current_user, article: @article)
      &.destroy

    render json: {message: "Article ##{@article.id} removed from favorite"}
  end

  def show
    authorize @article

    ViewedArticle.find_or_create_by!(article: @article, user: current_user) if current_user

    render json: @article
  end

  def update
    authorize @article

    if @article.update(article_params)
      render json: @article
    else
      render json: {errors: @article.errors.full_messages}
    end
  end

  def destroy
    authorize @article

    @article.destroy

    render json: @article
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params
      .require(:article)
      .permit(:title, :anounce, :body, :published)
  end
end
