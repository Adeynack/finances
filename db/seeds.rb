# frozen_string_literal: true

User.create!(
  email: "admin@example.com",
  password: ENV["FINANCES_ADMIN_PASSWORD"] || "adminadmin",
  admin: true,
  display_name: "Administrator"
)
