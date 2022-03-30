# frozen_string_literal: true

class UserResource < Avo::BaseResource
  self.title = :email
  self.includes = []

  field :id, as: :id
  field :email, as: :text, required: true, sortable: true
  field :password, as: :password, required: true
  field :display_name, as: :text, required: true, sortable: true
  field :admin, as: :boolean
  field :last_book, as: :belongs_to, hide_on: :index

  field :books, as: :has_many
end
