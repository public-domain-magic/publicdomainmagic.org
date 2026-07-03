class CreateCatalogFormOfExpressions < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_form_of_expressions do |t|
      t.string :name

      t.timestamps
    end
  end
end
