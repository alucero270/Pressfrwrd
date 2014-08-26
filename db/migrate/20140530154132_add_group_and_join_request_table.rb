class AddGroupAndJoinRequestTable < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.timestamp
    end

    add_reference :ideas, :group

    create_table :join_requests do |t|
      t.references :group, index: true
      t.references :idea, index: true
      t.column :status, :integer, default: 0
      t.timestamp
    end
    
    create_table :votes do |t|
      t.references :join_request, index: true
      t.references :user, index: true
      t.column :status, :integer, default: 0
    end
  end
end
