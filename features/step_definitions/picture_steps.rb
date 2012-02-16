Then /^picture record for "([^"]*)" with title "([^"]*)" should exist$/ do |case_title, pic_title|  
  raise ActiveRecord::RecordNotFound unless 
    Case.find_by_title(case_title).pictures.find_by_title(pic_title)
end

Then /^picture record for "([^"]*)" should not exist$/ do |case_title|
  Case.find_by_title(case_title).pictures.count.should == 0
end

Then /^file for picture "([^"]*)" in "([^"]*)" should exist$/ do |pic_title, case_title|  
  p = Case.find_by_title(case_title).pictures.find_by_title(pic_title)
  unless p 
    raise ActiveRecord::RecordNotFound
  else
    raise "Picture file not found (#{p.full_filepath})" unless File.exists?(p.full_filepath)
  end  
end

Then /^there should be (\d+) picture files in the system$/ do |picture_files_count|
  files_root = APP_CONFIG['files_path']
  Dir[files_root + '*/pictures/*'].count.should == picture_files_count.to_i
end
