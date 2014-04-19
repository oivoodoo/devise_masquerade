class Admin::DashboardController < ApplicationController
  before_filter :authenticate_admin_user!
  before_filter :masquerade_admin_user!

  def index
    @users = Admin::User.where("admin_users.id != ?", current_admin_user.id).all
  end
end

