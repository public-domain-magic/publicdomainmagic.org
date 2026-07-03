class CreateCatalogFormOfWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_form_of_works do |t|
      t.string :name

      t.timestamps
    end
  end
end
