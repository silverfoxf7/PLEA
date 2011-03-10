class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.integer :amount # the amount of the bid for a project
      t.integer :user_id  # ID of the person posting a bid
      t.integer :jobpost_id # ID of the project being bid on

      t.timestamps
    end
    add_index :bids, :user_id
    add_index :bids, :jobpost_id
  end

  def self.down
    drop_table :bids
  end
end
