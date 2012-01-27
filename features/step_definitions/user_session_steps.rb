User.send(:cattr_accessor, :current)

Given /I am signed in/ do
  User.current = FactoryGirl.create(:user)

  step %|I go to the sign-in page|
  step %|I sign-in as "#{User.current.email}" with password "password"|
end

