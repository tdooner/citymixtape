class RenameStarsToSessions < ActiveRecord::Migration[5.0]
  def change
    rename_table :stars, :sessions
  end
end
