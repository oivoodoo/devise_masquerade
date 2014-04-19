class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :masquerade_user!

  def index
    @users = User.where("users.id != ?", current_user.id).all
  end
end

