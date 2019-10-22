FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    password  { 'password' }
    password_confirmation { 'password' }
  end

  factory :admin_user, :class => 'Admin::User' do
    sequence(:email) { |i| "admin#{i}@example.com" }
    password  { 'password' }
    password_confirmation { 'password' }
  end

  factory :student do
    sequence(:email) { |i| "student#{i}@example.com" }
    password  { 'password' }
    password_confirmation { 'password' }
  end
end

