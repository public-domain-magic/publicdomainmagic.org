class CreateCatalogConditions < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_conditions do |t|
      t.string :name

      t.timestamps
    end
  end
end
