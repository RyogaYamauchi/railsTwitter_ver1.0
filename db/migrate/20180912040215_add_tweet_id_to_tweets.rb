class AddTweetIdToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :tweetID, :string
  end
end
