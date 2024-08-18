# frozen_string_literal: true

module Types
  class CreateRegisterInputType < Types::BaseInputObject
    argument :id, ID, required: false
    auto_arguments Register,
      :created_at,
      :name,
      :type,
      :book_id,
      :parent_id,
      :starts_at,
      :expires_at,
      :currency_iso_code,
      :notes,
      :initial_balance,
      :active,
      :default_category_id,
      :institution_name,
      :account_number,
      :iban,
      :annual_interest_rate,
      :credit_limit,
      :card_number
  end
end
