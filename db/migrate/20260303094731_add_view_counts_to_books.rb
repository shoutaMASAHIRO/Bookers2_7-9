class AddViewCountsToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :view_counts, :integer, default: 0
  end
end
