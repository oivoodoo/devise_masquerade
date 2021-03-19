When("I have devise masquerade expiration time in {int} second") do |seconds|
  Devise.masquerade_expires_in = seconds.second
end

Then("I waited for {int} seconds") do |seconds|
  sleep(seconds)

  Devise.masquerade_expires_in = 5.minutes
end
