class AddEmailNameAndNewsletterOptInToSessions < ActiveRecord::Migration[5.0]
  def change
    change_table :sessions do |t|
      t.string :name
      t.string :email
      t.boolean :newsletter_opt_in
    end
  end
end
