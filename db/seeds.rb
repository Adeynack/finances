# frozen_string_literal: true

User.find_or_initialize_by(email: "admin@example.com").tap do |user|
  user.update!(
    password: ENV["FINANCES_ADMIN_PASSWORD"] || "adminadmin",
    admin: true,
    display_name: "Administrator"
  )
end
