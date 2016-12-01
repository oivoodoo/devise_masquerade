class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :masquerade_user!

  def index
    @users = User.where("users.id != ?", current_user.id).all
  end
end

