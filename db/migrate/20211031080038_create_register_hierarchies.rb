# frozen_string_literal: true

class CreateRegisterHierarchies < ActiveRecord::Migration[6.1]
  def change
    create_table :register_hierarchies, id: false do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :register_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "register_anc_desc_idx"

    add_index :register_hierarchies, [:descendant_id],
      name: "register_desc_idx"
  end
end
