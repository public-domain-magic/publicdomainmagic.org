class CreateCatalogIntendedAudiences < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_intended_audiences do |t|
      t.string :name

      t.timestamps
    end
  end
end
