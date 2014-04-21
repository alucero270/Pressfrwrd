class ChangeStringToTextContentInIdeas < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :ideas do |t|
        dir.up   { t.change :content, :text }
        dir.down { t.change :content, :string }
      end
    end
  end
end
