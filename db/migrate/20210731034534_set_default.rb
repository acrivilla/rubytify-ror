class SetDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :artists, :image, :string, default: ""
  end
end
