class AddBetterToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :better, :boolean, default: false
  end
end
