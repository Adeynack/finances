# frozen_string_literal: true

# TODO: Shimmer
module ClassRefinements
  refine Class do
    def find_child_from_files(path: "app/models/#{name.pluralize.underscore}/*.rb", namespace: name.pluralize)
      all_files = Dir[Rails.root.join(path)]
      namespace_part = namespace.to_s
      namespace_part += "::" unless namespace_part.ends_with?("::")
      all_files.map! { |p| (namespace_part + File.basename(p, ".rb").camelize).safe_constantize }
      all_files.filter!(&:present?)
      all_files.filter! { |c| c.ancestors[1..].include?(self) }
      all_files
    end
  end
end
