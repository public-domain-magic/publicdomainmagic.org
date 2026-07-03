class CreateCatalogSeries < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_series do |t|
      t.string :name

      t.timestamps
    end
  end
end
