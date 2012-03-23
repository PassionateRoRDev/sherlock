class Viewer < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'viewer_id'
  belongs_to :case
end
  