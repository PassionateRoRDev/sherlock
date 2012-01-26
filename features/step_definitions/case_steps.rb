
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
