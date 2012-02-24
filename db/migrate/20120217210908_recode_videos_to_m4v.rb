class RecodeVideosToM4v < ActiveRecord::Migration
  def up
    Video.all.each do |video|
      video.recode_to [:m4v]
    end
  end

  def down
  end
end
