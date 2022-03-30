# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2021_10_31_080038) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "exchange_status", ["uncleared", "reconciling", "cleared"]
  create_enum "register_type", ["Bank", "Card", "Investment", "Asset", "Liability", "Loan", "Institution", "Expense", "Income"]
  create_enum "reminder_mode", ["manual", "auto_commit", "auto_cancel"]

  create_table "books", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.string "default_currency_iso_code", limit: 3, null: false
    t.index ["owner_id"], name: "index_books_on_owner_id"
  end

  create_table "exchanges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", null: false, comment: "Date the exchange appears in the book."
    t.bigint "register_id", null: false, comment: "From which register does the money come from."
    t.string "cheque", comment: "Cheque information."
    t.string "description", null: false, comment: "Label of the exchange."
    t.text "memo", comment: "Detail about the exchange."
    t.enum "status", default: "uncleared", null: false, enum_type: "exchange_status"
    t.index ["date"], name: "index_exchanges_on_date"
    t.index ["register_id"], name: "index_exchanges_on_register_id"
  end

  create_table "import_origins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.string "external_system", null: false
    t.string "external_id", null: false
    t.index ["subject_type", "subject_id", "external_system", "external_id"], name: "index_import_origins_unique", unique: true
    t.index ["subject_type", "subject_id"], name: "index_import_origins_on_subject"
    t.index ["subject_type", "subject_id"], name: "index_import_origins_on_subject_type_and_subject_id"
  end

  create_table "register_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "register_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "register_desc_idx"
  end

  create_table "registers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.enum "type", null: false, enum_type: "register_type"
    t.bigint "book_id", null: false
    t.bigint "parent_id", comment: "A null parent means it is a root register."
    t.date "starts_at", null: false, comment: "Opening date of the register."
    t.date "expires_at", comment: "Optional expiration date of the register (ex: for a credit card)."
    t.string "currency_iso_code", limit: 3, null: false
    t.text "notes"
    t.bigint "initial_balance", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.bigint "default_category_id", comment: "The category automatically selected when entering a new exchange from this register."
    t.string "institution_name", comment: "Name of the institution (ex: bank) managing the registry (ex: credit card)."
    t.string "account_number", comment: "Number by which the register is referred to (ex: bank account number)."
    t.string "iban", comment: "In the case the register is identified by an International Bank Account Number (IBAN)."
    t.decimal "interest_rate", comment: "In the case the register is being charged interests, its rate (ex: credit card)."
    t.bigint "credit_limit", comment: "In the case the register has a credit limit (ex: credit card, credit margin)."
    t.string "card_number", comment: "In the case the register is linked to a card, its number (ex: a credit card)."
    t.index ["book_id"], name: "index_registers_on_book_id"
    t.index ["default_category_id"], name: "index_registers_on_default_category_id"
    t.index ["parent_id"], name: "index_registers_on_parent_id"
  end

  create_table "reminder_splits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reminder_id", null: false
    t.bigint "register_id", null: false, comment: "To which register is the money going to for this split."
    t.integer "amount", null: false
    t.integer "counterpart_amount", comment: "Amount in the destination register, if it differs from 'amount' (ex: an exchange rate applies)."
    t.text "memo", comment: "Detail about the exchange, to show in the destination register."
    t.enum "status", default: "uncleared", null: false, enum_type: "exchange_status"
    t.index ["register_id"], name: "index_reminder_splits_on_register_id"
    t.index ["reminder_id"], name: "index_reminder_splits_on_reminder_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "book_id", null: false
    t.string "title", null: false
    t.text "description"
    t.enum "mode", default: "manual", null: false, enum_type: "reminder_mode"
    t.date "first_date", null: false, comment: "From when to apply the reminder."
    t.date "last_date", comment: "Until when to apply the reminder (optional)."
    t.jsonb "recurrence", comment: "Expressed as a 'Montrose::Recurrence' JSON. For one-shot reminders, `nil`, happening only on `first_date`."
    t.date "last_commit_at", comment: "Last time for which this reminder was committed. `nil` means it never was."
    t.date "next_occurence_at", comment: "Next time this reminder is scheduled for. Serves as a cache to quickly obtain all reminders that are due."
    t.bigint "exchange_register_id", null: false, comment: "From which register does the money come from."
    t.string "exchange_description", null: false, comment: "Label of the exchange."
    t.text "exchange_memo", comment: "Detail about the exchange."
    t.enum "exchange_status", default: "uncleared", null: false, enum_type: "exchange_status"
    t.index ["book_id"], name: "index_reminders_on_book_id"
    t.index ["exchange_register_id"], name: "index_reminders_on_exchange_register_id"
  end

  create_table "splits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exchange_id", null: false
    t.bigint "register_id", null: false, comment: "To which register is the money going to for this split."
    t.integer "amount", null: false
    t.integer "counterpart_amount", comment: "Amount in the destination register, if it differs from 'amount' (ex: an exchange rate applies)."
    t.text "memo", comment: "Detail about the exchange, to show in the destination register."
    t.enum "status", default: "uncleared", null: false, enum_type: "exchange_status"
    t.index ["exchange_id"], name: "index_splits_on_exchange_id"
    t.index ["register_id"], name: "index_splits_on_register_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tag_id", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.index ["subject_type", "subject_id"], name: "index_taggings_on_subject"
    t.index ["subject_type", "subject_id"], name: "index_taggings_on_subject_type_and_subject_id"
    t.index ["tag_id", "subject_type", "subject_id"], name: "index_taggings_on_tag_id_and_subject_type_and_subject_id", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.boolean "admin", default: false, null: false
    t.string "display_name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.bigint "last_book_id", comment: "Last opened book."
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_book_id"], name: "index_users_on_last_book_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "books", "users", column: "owner_id"
  add_foreign_key "exchanges", "registers"
  add_foreign_key "registers", "books"
  add_foreign_key "registers", "registers", column: "default_category_id"
  add_foreign_key "registers", "registers", column: "parent_id"
  add_foreign_key "reminder_splits", "registers"
  add_foreign_key "reminder_splits", "reminders"
  add_foreign_key "reminders", "books"
  add_foreign_key "reminders", "registers", column: "exchange_register_id"
  add_foreign_key "splits", "exchanges"
  add_foreign_key "splits", "registers"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "books", column: "last_book_id"
end
