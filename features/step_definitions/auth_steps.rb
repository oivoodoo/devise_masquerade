Given /^I logged in$/ do
  @user = create(:user)

  visit '/'

  fill_in 'user[email]', :with => @user.email
  fill_in 'user[password]', :with => 'password'

  click_on 'Log in'
end

