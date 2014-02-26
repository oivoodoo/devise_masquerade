module Authentication
  def logged_in
    @user ||= create(:user)

    sign_in(@user, :bypass => true)
  end

  def current_user
    controller.send(:current_user)
  end
end

