# frozen_string_literal: true
# typed: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           not null, indexed
#  encrypted_password     :string           not null
#  admin                  :boolean          default(FALSE), not null
#  display_name           :string           not null
#  reset_password_token   :string           indexed
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  default_book_id        :uuid             indexed
#
class User < ApplicationRecord
  extend T::Sig

  T.unsafe(self).devise :database_authenticatable, :recoverable, :rememberable, :registerable, :validatable # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :books, dependent: :destroy, foreign_key: "owner_id", inverse_of: :owner

  belongs_to :default_book, class_name: "Book", dependent: false, inverse_of: false, optional: true

  validates :email, presence: true
  validates :display_name, presence: true
  validates :encrypted_password, presence: true
end
