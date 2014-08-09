class AddMergedIntoToJoinRequests < ActiveRecord::Migration
  def change
    add_reference :join_requests, :merged_into
    add_reference :ideas, :merged_into
  end
end
