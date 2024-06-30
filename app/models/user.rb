# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string           not null, indexed
#  password_digest :string           not null
#  admin           :boolean          default(FALSE), not null
#  display_name    :string           not null
#  default_book_id :uuid             indexed                    Last opened book.
#
class User < ApplicationRecord
  has_secure_password

  has_many :api_sessions, dependent: :delete_all
  has_many :books, dependent: :destroy, foreign_key: "owner_id", inverse_of: :owner

  belongs_to :default_book, class_name: "Book", dependent: false, inverse_of: false, optional: true

  validates :email,
    presence: true,
    format: {with: /(.+)@(.+)/, message: "has invalid format"},
    uniqueness: {case_sensitive: false},
    length: {minimum: 4, maximum: 254}
  validates :display_name, presence: true
  validates :password_digest, presence: true
end
