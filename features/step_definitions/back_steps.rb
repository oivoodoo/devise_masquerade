Given /^I have a user for masquerade$/ do
  @mask = create(:user)
end

When /^I am on the users page$/ do
  visit '/'
end

When /^I login as one user$/ do
  click_on "Login as"
end

Then /^I should be login as this user$/ do
  find('.current_user').should have_content(@mask.email)
end

When /^I press back masquerade button$/ do
  click_on "Back masquerade"
end

Then /^I should be login as owner user$/ do
  find('.current_user').should have_content(@user.email)
end

