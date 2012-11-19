FactoryGirl.define do
  sequence(:email) { |i| "john#{i}@example.com" }

  factory :user do
    email
    password 'password'
    password_confirmation 'password'
  end
end

