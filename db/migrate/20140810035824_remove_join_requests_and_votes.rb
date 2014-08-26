class RemoveJoinRequestsAndVotes < ActiveRecord::Migration
  class JoinRequest < ActiveRecord::Base 
  end
  class Vote <  ActiveRecord::Base
  end

  def change
    reversible do |dir|
      dir.up do
        JoinRequest.delete_all
        Vote.delete_all
      end
      dir.down do
        JoinRequest.delete_all
        Vote.delete_all
      end
    end
  end
end
