class CreateAudioAssets < ActiveRecord::Migration
  def change
    create_table :audio_assets do |t|
      t.references :block, :null => false
      t.string :path, :null => false
      t.timestamps
    end
  end
end
