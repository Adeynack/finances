# frozen_string_literal: true

class RegisterResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    params["via_reflection_class"] = "Register" if params.key?("via_reflection_class")
    s = scope
    s = s.where(book: Register.find(params[:via_reflection_id]).book) if params[:via_reflection_id].present?
    s.ransack(id_eq: params[:q], name_cont: params[:q], notes_cont: params[:q], institution_name_cont: params[:q], iban_cont: params[:q], card_number_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id, readonly: true, hide_on: :index
  field :name, as: :text, required: true, link_to_resource: true, hide_on: :index
  field :hierarchical_name, as: :text, readonly: true, link_to_resource: true, hide_on: [:edit, :new]

  field :book, as: :belongs_to
  field :parent, as: :belongs_to, use_resource: RegisterResource, searchable: true

  field :search_label, as: :text, hide_on: :all, as_label: true do |model|
    model.hierarchical_name
  end
  field :search_description, as: :text, hide_on: :all, as_description: true do |model|
    model.name
  end
end
