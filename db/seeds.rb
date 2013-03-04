# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

admins = ['jw@mustmodify.com', 'kingeri@gmail.com', 'pebeauchemin@gmail.com']
admins.each do |e|
  User.find_or_create_by_email(
    :email => e, 
    :password => 'sherl0ckdocs40!', 
    :password_confirmation => 'sherl0ckdocs40!',
    :admin => true)
end

plans = [
  
  {
    :chargify_handle  => :free_trial,
    :chargify_slug    => nil,
    :price            => 0,    
    :cases_max        => 3,
    :extra_case_price => 0,
    :clients_max      => 0,
    :storage_max_mb   => 1024 * 2
  },
  
  {
    :chargify_handle  => :independent,
    :chargify_slug    => 'h/285859',
    :price            => 9,        
    :cases_max        => 3,
    :extra_case_price => 4,
    :clients_max      => 15,
    :storage_max_mb   => 1024 * 2
  },
  {
    :chargify_handle  => :agency,
    :chargify_slug    => 'h/286025',
    :price            => 29,
    :cases_max        => 12,
    :extra_case_price => 3,
    :clients_max      => 100,
    :storage_max_mb   => 1024 * 5
  },
  
  {
    :chargify_handle  => :company,
    :chargify_slug    => 'h/927622',
    :price            => 59,    
    :cases_max        => 30,
    :extra_case_price => 2,
    :clients_max      => 250,
    :storage_max_mb   => 1024 * 12
  },
  
  {
    :chargify_handle  => :corporate,
    :chargify_slug    => 'h/286061',
    :price            => 99,    
    :cases_max        => 60,
    :extra_case_price => 1,
    :clients_max      => 0,
    :storage_max_mb   => 1024 * 25
  },
  
  {
    :chargify_handle  => :independent2,
    :chargify_slug    => 'h/3288587',
    :price            => 14,        
    :cases_max        => 5,
    :extra_case_price => 4,
    :clients_max      => 0,
    :storage_max_mb   => 1024 * 2
  },
  
  {
    :chargify_handle  => :payasyougo,
    :chargify_slug    => 'h/3288210',
    :price            => 3,        
    :cases_max        => 0,
    :extra_case_price => 5,
    :clients_max      => 0,
    :storage_max_mb   => 1024 * 1
  }
  
]

plans.each { |plan| SubscriptionPlan.find_or_create_by_chargify_handle plan }

