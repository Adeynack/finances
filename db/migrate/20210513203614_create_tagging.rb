# frozen_string_literal: true

class CreateTagging < ActiveRecord::Migration[6.1]
  def change
    create_table :tags, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false, index: {unique: true}
    end

    create_table :taggings, id: :uuid do |t|
      t.timestamps
      t.references :tag, type: :uuid, foreign_key: true, null: false
      t.references :subject, type: :uuid, polymorphic: true, null: false

      t.index [:subject_type, :subject_id]
      t.index [:tag_id, :subject_type, :subject_id], unique: true
    end
  end
end
