# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

admins = ['jw@mustmodify.com', 'kingeri@gmail.com', 'pebeauchemin@gmail.com']

admins.each do |e|
  User.find_or_create_by_email(:email => e, :password => 'password', :password_confirmation => 'password')
end

