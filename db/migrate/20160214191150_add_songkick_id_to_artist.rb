class AddSongkickIdToArtist < ActiveRecord::Migration[5.0]
  def change
    change_table :artists do |t|
      t.integer :songkick_id

      t.index :songkick_id
    end
  end
end
