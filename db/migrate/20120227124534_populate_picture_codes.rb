class PopulatePictureCodes < ActiveRecord::Migration
  def up
    Picture.all.each do |pic|
      if pic.unique_code.blank?
        pic.unique_code = Picture.generate_unique_code
        pic.save
      end
    end
  end

  def down
  end
end
