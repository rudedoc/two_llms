class AddRunningToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :running, :boolean, default: false
  end
end
