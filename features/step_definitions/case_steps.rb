Given /^I have a case entitled "(.*)"$/ do |title|
  Factory.create(:case, :title => title, :author => User.current)
end

Given /^(.*) has an html block(?: with content "(.*)")?$/ do |case_title, content|
  c = Case.find_by_title!(case_title)
  Factory.create(:html_detail, :block => Factory.create(:block, :case => c), :contents => content || "Lorem Ipsum")
end

When /^I click "([^"]*)" on the (\d+).. block$/ do |action_name, block_no|  
  block = find('.blocks-area').all('.block')[block_no.to_i - 1]
  unless block
    raise "Block not found (no: #{block_no})"
  else
    within block do
      click_link action_name
    end
  end
end
