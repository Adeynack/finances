# frozen_string_literal: true

module Mutations
  class CreateRegister < BaseMutation
    argument :register, Types::RegisterForCreateInputType, required: true

    field :register, Types::RegisterType, null: false

    def resolve(register:)
      register_attr = register.to_h
      import_origin = register_attr.delete(:import_origin)
      new_register = Register.new(**register_attr)
      authorize(new_register).save!
      new_register.import_origins.create!(external_id: import_origin[:id], external_system: import_origin[:system]) if import_origin
      {register: new_register}
    end
  end
end
