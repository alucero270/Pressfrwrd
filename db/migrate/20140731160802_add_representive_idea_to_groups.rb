class AddRepresentiveIdeaToGroups < ActiveRecord::Migration
  def change
    add_reference :ideas, :represented_by, index: true
    add_reference :ideas, :merged_to, index: true
    add_column :ideas, :merged_on, :datetime
    add_reference :join_requests, :to_idea, index: true
    reversible do |dir|
      dir.up do
        remove_reference :join_requests, :group
        remove_reference :ideas, :group, index: true
        drop_table :groups
      end
      dir.down do
        add_reference :join_requests, :group, index: true
        add_reference :ideas, :group, index: true
        create_table :groups do |t|
          t.timestamp
        end
      end
    end
  end
  
end
