class CreateCatalogExpressions < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_expressions do |t|
      t.string :title
      t.date :date
      t.string :identifier
      t.string :summary
      t.references :form_of_expression, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.references :work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
