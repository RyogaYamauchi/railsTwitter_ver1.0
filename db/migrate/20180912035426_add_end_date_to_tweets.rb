class AddEndDateToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :endDate, :string
  end
end
