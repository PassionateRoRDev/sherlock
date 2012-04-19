FactoryGirl.define do
  factory :user do
    email { "user@#{String.random(5)}.com" }
    password 'password'
    first_name 'John'
    last_name 'Smith'
  end
end

