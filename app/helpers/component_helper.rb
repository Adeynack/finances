# frozen_string_literal: true

module ComponentHelper
  def c
    @c ||= ComponentRegistry.new(self) do |c|
      c.register_partials "components"
      c.register :stack
    end
  end
end
