Then("I should see maquerade url") do
  page.html.should include('href="/users/masquerade?masquerade=')
end

When("I am on the users page with extra params") do
  visit '/extra_params'
end

Then("I should see maquerade url with extra params") do
  page.html.should include('href="/users/masquerade?key1=value1&amp;masquerade=')
end
