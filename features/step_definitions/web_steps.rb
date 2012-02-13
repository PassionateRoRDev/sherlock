
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Given /^I sign-in as "(.*?)" with password "(.*?)"$/ do |username, password|
  fill_in 'Email :', :with => username
  fill_in 'Password :', :with => password
  click_button 'Login'
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |element, value|
  fill_in(element, :with => value)
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^I press "([^"]*)"$/ do |button|
  click_button button
end

When /^I follow "([^"]*)"(?: within "(.*)")?$/ do |link_text, selection|
  if selection.nil?
    click_link(link_text)
  else
    find(selection).click_link(link_text)
  end
end

When /^I attach file "([^"]*)" to "([^"]*)"$/ do |filepath, field|
  attach_file(field, "#{Rails.root}/features/fixtures/files/#{filepath}")
end

When /^I create a new case with title "([^"]*)" and summary "([^"]*)"$/ do |title, summary|
  visit new_case_path
  fill_in "Title", :with => title
  fill_in "Summary", :with => summary
  click_button("Save")        
end

When /^I create a picture block in "([^"]*)" with title "([^"]*)" and file "([^"]*)"$/ do 
  |case_title, pic_title, pic_path|
  
  visit path_to('details page of "' + case_title + '"')
  click_link('Add picture block')
  fill_in 'Title', :with => pic_title
  attach_file("Select Image:", 
              "#{Rails.root}/features/fixtures/files/#{pic_path}")
  click_button('Save')  
  
end

Then /^page title should be "([^"]*)"$/ do |page_title|
  find('h1').should have_content(page_title)
end

Then /^I should see confirmation "([^"]*)"$/ do |confirmation|
  find('.flash-messages').find('.notice').should have_content(confirmation)
end

Then /^(?:|I )should see "(.*)"$/ do |expected|
  page.body.should include(expected)
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  page.should have_no_content(text)
end

Then /^the list of cases should contain (\d+) cases?$/ do |how_many|  
  find(:css, 'ol.cases').should match_exactly(how_many.to_i, "li")
end

