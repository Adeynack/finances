# frozen_string_literal: true

admin = User.find_or_create_by!(email: "admin@example.com") {
  it.assign_attributes(
    password: ENV["FINANCES_ADMIN_PASSWORD"] || "adminadmin",
    admin: true,
    display_name: "Administrator"
  )
}

book = Book.find_or_create_by!(name: "My Personal Finances", owner: admin) do
  it.assign_attributes(
    default_currency_iso_code: "EUR"
  )
end

admin.update! default_book: book
