class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true
      t.references :idea, index: true
      t.integer :value
    end

    change_table :ideas do |t|
      t.integer :likes_sum_cache, default: 0
    end
  end
end
