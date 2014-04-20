class RenameMicropostsToIdeas < ActiveRecord::Migration
  def change
    rename_table :microposts, :ideas
  end
end
