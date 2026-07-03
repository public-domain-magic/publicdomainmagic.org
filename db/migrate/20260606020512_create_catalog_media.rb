class CreateCatalogMedia < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_media do |t|
      t.string :name

      t.timestamps
    end
  end
end
