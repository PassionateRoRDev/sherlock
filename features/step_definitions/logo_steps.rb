Then /^I should have (\d+) logos? assigned$/ do |cnt|
  User.current.logos.count.should == cnt.to_i  
end

Then /^there should be (\d+) logo files? in the system$/ do |logo_files_count|
  files_root = APP_CONFIG['files_path']
  Dir[files_root + '*/logos/*'].count.should == logo_files_count.to_i
end