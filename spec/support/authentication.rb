module Authentication
  def logged_in
    @user ||= create(:user)
    sign_in(@user)
  end

  def current_user
    controller.send(:current_user)
  end

  def admin_logged_in
    @admin_user ||= create(:admin_user)
    sign_in(@admin_user)
  end

  def current_admin_user
    controller.send(:current_admin_user)
  end
end

