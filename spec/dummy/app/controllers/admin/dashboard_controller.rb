class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @users = Admin::User.where("admin_users.id != ?", current_admin_user.id).all
  end
end

