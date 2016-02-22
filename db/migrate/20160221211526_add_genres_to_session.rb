class AddGenresToSession < ActiveRecord::Migration[5.0]
  def change
    change_table :sessions do |t|
      t.jsonb :genres, null: false, default: '[]'
    end
  end
end
