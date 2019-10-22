Given /^I have a user for masquerade$/ do
  @user_mask = create(:user)
end

When /^I am on the users page$/ do
  visit '/'
end

When /^I login as one user$/ do
  find('.login_as').click
end

Then /^I should be login as this user$/ do
  find('.current_user').should have_content(@user_mask.email)
end

When /^I press back masquerade button$/ do
  click_on "Back masquerade"
end

Then /^I should be login as owner user$/ do
  find('.current_user').should have_content(@user.email)
end

Given /^I have a student for masquerade$/ do
  @student_mask = create(:student)
end

When /^I am on the students page$/ do
  visit '/students'
end

When /^I login as one student$/ do
  find('.login_as').click
end

Then /^I should be login as this student$/ do
  find('.current_student').should have_content(@student_mask.email)
end
