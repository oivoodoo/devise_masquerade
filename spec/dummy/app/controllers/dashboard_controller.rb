class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where("users.id != ?", current_user.id).all
  end

  def extra_params
    @users = User.where("users.id != ?", current_user.id).all
  end
end

