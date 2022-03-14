# frozen_string_literal: true

module Importable
  extend ActiveSupport::Concern

  included do
    has_many :import_origins, as: :subject, dependent: :delete_all
  end
end
