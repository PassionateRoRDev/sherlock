class PopulateVideoCodes < ActiveRecord::Migration
  def up
    Video.all.each do |video|
      if video.unique_code.blank?
        video.unique_code = Video.generate_unique_code
        video.save
      end
    end
  end

  def down
  end
end
