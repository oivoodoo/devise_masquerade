Given /^I logged in$/ do
  @user = create(:user)

  visit '/'

  fill_in 'user[email]', :with => @user.email
  fill_in 'user[password]', :with => 'password'

  click_on 'Log in'
end

Given("devise masquerade configured to use cache") do
  Devise.masquerade_storage_method = :cache
end

Given("devise masquerade configured to use session") do
  Devise.masquerade_storage_method = :session
end
