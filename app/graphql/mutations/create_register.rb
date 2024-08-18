# frozen_string_literal: true

module Mutations
  class CreateRegister < BaseMutation
    argument :register, Types::CreateRegisterInputType, required: true

    field :register, Types::RegisterType, null: false

    def resolve(register:)
      new_register = autorize(Register).create!(**register)
      {register: new_register}
    end
  end
end
