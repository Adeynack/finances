# frozen_string_literal: true

User.create! email: "admin@example.com", password: ENV["FINANCES_ADMIN_PASSWORD"] || "adminadmin", display_name: "Administrator"
