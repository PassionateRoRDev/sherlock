
# ---------------------------------------------------------------------------------------------------
# This script pushes the SherlockDocs investigators to the Infusionsoft database. The necessary 
# information is collected from the current (last) subscription of the user.
# As the synchronization will be continuous, this script is expected to be launched only once, at the 
# very first initialization.
# 
# Usage: 
# 
# - login to the live server
# - launch the rails console
# - invoke the following:
#   InfusionsoftSynchronizer.launch
#   exit
# ----------------------------------------------------------------------------------------------------
class InfusionsoftSynchronizer
  include InfusionsoftUtils
  
  # Launches the sqls
  def self.launch
    Rails.logger.info "INFUSIONSOFT > Starts to synchronize."

    # Process the investigators
    users = User.investigators
    Rails.logger.info "INFUSIONSOFT > Number of users to process: #{users.length}"
    users.each do |user|
      Rails.logger.info "INFUSIONSOFT > Processing #{user.email}"
      InfusionsoftUtils.update_contact_by_user(user, user.current_subscription)
    end
    
    Rails.logger.info "INFUSIONSOFT > Finished with synchronization."
  end

end