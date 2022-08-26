# frozen_string_literal: true

class BookResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], owner_display_name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id, readonly: true, sortable: true, link_to_resource: true, hide_on: :index
  field :name, as: :text, required: true, searchable: true, link_to_resource: true
  field :owner, as: :belongs_to, required: true, searchable: true
  field :default_currency_iso_code, as: :text, required: true
  field :created_at, as: :date, readonly: true, hide_on: :edit

  field :accounts, as: :has_many
  field :categories, as: :has_many
end
