class Api::V1::ArticlesController < ApplicationController
  before_action :set_article, only: %i[show update destroy]
  after_action :verify_authorized

  def create
    authorize Article

    article = Article.new(article_params)
    article.user = current_user

    if article.save
      render json: article
    else
      render json: {errors: article.errors.full_messages}
    end
  end

  def show
    authorize @article

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
