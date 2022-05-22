class Api::V1::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_article, only: %i[show]

  def create
    article = Article.new(article_params)

    if article.save
      render json: article
    else
      render json: {errors: article.errors.full_messages}
    end
  end

  def show
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
