class Api::V1::UsersController < ApplicationController
  def authors
    users = User.authors

    render json: users
  end
end
