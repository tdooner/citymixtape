class CreateLocationSearchResults < ActiveRecord::Migration[5.0]
  def change
    create_table :location_search_results do |t|
      t.string :query
      t.text :results

      t.timestamps
    end
  end
end
