# frozen_string_literal: true

class CreateImportOrigins < ActiveRecord::Migration[6.1]
  def change
    create_table :import_origins, id: :uuid do |t|
      t.timestamps
      t.references :subject, type: :uuid, polymorphic: true, null: false
      t.string :external_system, null: false
      t.string :external_id, null: false

      t.index [:subject_type, :subject_id]
      t.index [:subject_type, :subject_id, :external_system, :external_id], unique: true, name: "index_import_origins_unique"
    end
  end
end
