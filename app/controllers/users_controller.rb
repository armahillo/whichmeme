class UsersController < ApplicationController
  authorize_resource

  def show
    @user = User.find(params[:id])
    @best_types = @user.best_types(5)
  end

  def profile
    @user = User.find(current_user)
    @best_types = @user.best_types(5)
  end
end
