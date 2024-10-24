# frozen_string_literal: true

module Mutations
  class CreateAccount < BaseMutation
    argument :account, Types::AccountForCreateInputType, required: true

    field :account, Types::AccountType, null: false

    def resolve(account:)
      account_attr = account.to_h
      import_origin = account_attr.delete(:import_origin)
      new_account = Register.new(**account_attr)
      authorize(new_account).save!
      new_account.create_import_origin! external_id: import_origin[:id], external_system: import_origin[:system] if import_origin
      {account: new_account}
    end
  end
end
