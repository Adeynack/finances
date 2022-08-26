# frozen_string_literal: true

class UserResource < Avo::BaseResource
  self.title = :display_name
  self.description = -> { model.email }
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], email_cont: params[:q], display_name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :email, as: :text, required: true, sortable: true
  field :password, as: :password, required: true
  field :display_name, as: :text, required: true, sortable: true
  field :admin, as: :boolean
  field :last_book, as: :belongs_to, hide_on: :index

  field :books, as: :has_many

  field :search_label, as: :text, hide_on: :all, as_label: true do |model|
    model.display_name
  end
  field :search_description, as: :text, hide_on: :all, as_description: true do |model|
    model.email
  end
end
