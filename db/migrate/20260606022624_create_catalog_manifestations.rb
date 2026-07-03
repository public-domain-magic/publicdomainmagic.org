class CreateCatalogManifestations < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_manifestations do |t|
      t.string :title
      t.string :statement_of_responsibility
      t.string :edition_or_issue
      t.date :date_of_publication
      t.references :form_of_expression, null: false, foreign_key: true
      t.references :medium, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.references :series, null: false, foreign_key: true
      t.references :expression, null: false, foreign_key: true

      t.timestamps
    end
  end
end
