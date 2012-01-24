
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^I sign\-in as "(.*?)" with password "(.*?)"$/ do |username, password|
  fill_in 'Email', :with => username
  fill_in 'Password', :with => password
  click_button 'Sign in'
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |element, value|
  fill_in(element, :with => value)
end

When /^I press "([^"]*)"$/ do |button|
  click_button button
end

When /^I follow "([^"]*)"$/ do |link_text|
  click_link(link_text)
end

When /^I attach file "([^"]*)" to "([^"]*)"$/ do |filepath, field|
  attach_file(field, "#{Rails.root}/features/fixtures/files/#{filepath}")
end

Then /^page title should be "([^"]*)"$/ do |page_title|
  find('h1').should have_content(page_title)
end

Then /^I should see confirmation "([^"]*)"$/ do |confirmation|
  find('.flash-messages').find('#notice').should have_content(confirmation)
end

Then /^the list of cases should contain (\d+) cases?$/ do |how_many|  
  find(:css, 'ol.cases').should match_exactly(how_many.to_i, "li")
end



