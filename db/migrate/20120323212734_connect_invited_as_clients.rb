class ConnectInvitedAsClients < ActiveRecord::Migration
      
  def up
    Viewer.all.each do |viewer|
      author = viewer.case.author
      # if I am not an author of the case, then I have been invited by
      # the author of the case
      unless viewer.user.id == author.id
        unless author.clients.include?(viewer.user)
          author.clients << viewer.user
          author.save!
        end
      end
    end
  end

  def down
  end
end
