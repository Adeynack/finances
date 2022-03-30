# frozen_string_literal: true

class RegisterResource < Avo::BaseResource
  self.title = :name
  self.includes = []

  field :id, as: :id
  field :name, as: :text, required: true
end
