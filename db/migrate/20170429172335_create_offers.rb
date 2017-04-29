class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.belongs_to :customer, foreign_key: true

      t.timestamps
    end
  end
end
