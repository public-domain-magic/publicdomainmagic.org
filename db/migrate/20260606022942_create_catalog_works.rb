class CreateCatalogWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_works do |t|
      t.string :title
      t.date :date
      t.string :identifier
      t.references :form_of_work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
