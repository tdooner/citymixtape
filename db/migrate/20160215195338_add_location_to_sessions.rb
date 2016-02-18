class AddLocationToSessions < ActiveRecord::Migration[5.0]
  def change
    change_table :sessions do |t|
      t.integer :metro_area_id
    end
  end
end
