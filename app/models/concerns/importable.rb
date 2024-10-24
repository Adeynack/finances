# frozen_string_literal: true

module Importable
  extend ActiveSupport::Concern

  included do
    has_one :import_origin, as: :subject, dependent: :destroy
  end
end
