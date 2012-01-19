
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^page title should be "([^"]*)"$/ do |page_title|
  find('h1').should have_content(page_title)
end

Given /^I sign\-in as "(.*?)" with password "(.*?)"$/ do |username, password|
  fill_in 'Email', :with => username
  fill_in 'Password', :with => password
  click_button 'Sign in'
end
