# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :bigint           not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :bigint           not null, indexed
#  default_currency_iso_code :string(3)        not null
#
class Book < ApplicationRecord
  include Currencyable
  include Importable

  belongs_to :owner, class_name: "User"

  has_many :book_roles, dependent: :destroy
  # To get root register: book.registers.root
  has_many :registers, dependent: :destroy
  has_many :reminders, dependent: :destroy

  has_currency :default_currency
end
