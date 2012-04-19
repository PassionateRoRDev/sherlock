class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscription_plan
end
