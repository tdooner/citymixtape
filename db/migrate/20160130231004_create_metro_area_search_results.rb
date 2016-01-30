class CreateMetroAreaSearchResults < ActiveRecord::Migration[5.0]
  def change
    create_table :metro_area_search_results, id: false do |t|
      t.integer :metro_area_id, null: false, primary_key: true
      t.text :results

      t.timestamps
    end
  end
end
