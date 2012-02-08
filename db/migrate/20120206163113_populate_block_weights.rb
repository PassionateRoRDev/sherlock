class PopulateBlockWeights < ActiveRecord::Migration
  def up
    Case.all.each do |c|
      weight = 1
      c.blocks.each do |block|
        block.weight = weight
        block.save
        weight += 1
      end
    end
  end

  def down
    Block.all.each do |block|
      block.weight = 0
      block.save
    end
  end
end
