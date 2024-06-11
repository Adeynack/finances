# frozen_string_literal: true

require "rails_helper"

RSpec.describe Register do
  describe "KNOWN_TYPES" do
    it "lists all types in DB enum" do
      db_register_types = Register.connection.execute("SELECT unnest(enum_range(NULL::register_type))").values.flatten
      expect(Register::KNOWN_TYPES).to match_array db_register_types
    end
  end
end
