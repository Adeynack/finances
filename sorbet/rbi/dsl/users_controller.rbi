# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `UsersController`.
# Please instead update this file by running `bin/tapioca dsl UsersController`.

class UsersController
  sig { returns(HelperProxy) }
  def helpers; end

  module HelperMethods
    include ::Ransack::Helpers::FormHelper
    include ::Turbo::DriveHelper
    include ::Turbo::FramesHelper
    include ::Turbo::IncludesHelper
    include ::Turbo::StreamsHelper
    include ::ActionView::Helpers::CaptureHelper
    include ::ActionView::Helpers::OutputSafetyHelper
    include ::ActionView::Helpers::TagHelper
    include ::Turbo::Streams::ActionHelper
    include ::ActionText::ContentHelper
    include ::ActionText::TagHelper
    include ::ViteRails::TagHelpers
    include ::ActionController::Base::HelperMethods
    include ::ApplicationHelper
    include ::HeaderBarHelper
    include ::DeviseHelper
    include ::Pundit::Helper

    sig { params(id: T.untyped).returns(T.untyped) }
    def close_modal_path(id = T.unsafe(nil)); end

    sig { params(url: T.untyped, id: T.untyped, size: T.untyped, close: T.untyped).returns(T.untyped) }
    def modal_path(url, id: T.unsafe(nil), size: T.unsafe(nil), close: T.unsafe(nil)); end

    sig { params(record: T.untyped).returns(T.untyped) }
    def policy(record); end

    sig { params(url: T.untyped, id: T.untyped, selector: T.untyped, placement: T.untyped).returns(T.untyped) }
    def popover_path(url, id: T.unsafe(nil), selector: T.unsafe(nil), placement: T.unsafe(nil)); end

    sig { params(scope: T.untyped).returns(T.untyped) }
    def pundit_policy_scope(scope); end

    sig { returns(T.untyped) }
    def pundit_user; end
  end

  class HelperProxy < ::ActionView::Base
    include HelperMethods
  end
end
