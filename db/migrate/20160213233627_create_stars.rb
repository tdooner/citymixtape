class CreateStars < ActiveRecord::Migration[5.0]
  def change
    create_table :stars, id: false do |t|
      t.string :session_id, primary_key: true
      t.text :stars
    end
  end
end
