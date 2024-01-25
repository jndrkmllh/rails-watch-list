class AddImageUrlToList < ActiveRecord::Migration[7.1]
  def change
    add_column :lists, :image_url, :text
  end
end
