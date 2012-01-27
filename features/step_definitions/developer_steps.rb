Then 'display the page' do
  puts "\n\n\n#{page.body.to_s}\n\n\n"
end

Then /display "(.*)"$/ do |selector|
  node = find(selector)
  if node
    puts ">>> #{node.tag_name}"
    puts ">>> #{node.text}"
  else
    puts ">>> Could not find node based on selector \"#{selector}\""
  end
end

