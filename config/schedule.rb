# More info about "whenever" scheduler:
# https://github.com/javan/whenever/

every 12.hours do
  runner "Subscription.revise_records"
end