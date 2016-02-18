class AddGenresToArtist < ActiveRecord::Migration[5.0]
  def change
    change_table :artists do |t|
      t.text :genres, default: '[]', null: false
    end
  end
end
