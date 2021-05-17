# frozen_string_literal: true

module HashRefinements
  refine Hash do
    # Remove recursively any key being `null` or empty, using `.present?` on them except for
    # boolean values (`false.present?`` would be false, but it is not `null`).
    def minimize_presence!
      each_key do |key|
        value = self[key]
        value.minimize_presence! if value.is_a?(Hash)
        delete(key) unless value.present? || value.is_a?(FalseClass)
      end
      self
    end
  end
end
