class AddTitleToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :title, :string
  end
end
