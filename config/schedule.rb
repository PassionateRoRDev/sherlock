# More info about "whenever" scheduler:
# https://github.com/javan/whenever/

# set :environment, 'development' 

every 1.minutes do
  runner 'Subscription.revise_records'
end