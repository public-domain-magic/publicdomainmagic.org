class CreateCatalogLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_languages do |t|
      t.string :name
      t.string :code, limit: 2

      t.timestamps
    end
    add_index :catalog_languages, :code, unique: true
  end
end
