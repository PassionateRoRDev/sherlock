class MoveLogoInformation < ActiveRecord::Migration
  def up
    Letterhead.all.each do |letterhead|
      if letterhead.logo_path
        Logo.create(
          :user         => letterhead.user,
          :letterhead   => letterhead,
          :content_type => letterhead.logo_content_type,
          :path         => letterhead.logo_path
        )
      end
    end
    
    remove_column :letterheads, :logo_path
    remove_column :letterheads, :logo_content_type
    
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
