
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^page title should be "([^"]*)"$/ do |page_title|
  find('h1').should have_content(page_title)
end
