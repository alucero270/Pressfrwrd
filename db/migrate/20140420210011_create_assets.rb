class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :idea
      t.attachment :file
    end
  end
end
