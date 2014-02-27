module Authentication
  def logged_in
    @user ||= create(:user)

    sign_in(@user, :bypass => Devise.masquerade_bypass_warden_callback)
  end

  def current_user
    controller.send(:current_user)
  end
end

