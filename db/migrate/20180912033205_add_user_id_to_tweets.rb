class AddUserIdToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :userID, :string
  end
end
