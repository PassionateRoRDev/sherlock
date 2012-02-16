Then /^I should have (\d+) letterheads? assigned$/ do |cnt|
  Letterhead.where(:user_id => User.current.id).count.should == cnt.to_i
end
