# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `shimmer` gem.
# Please instead update this file by running `bin/tapioca gem shimmer`.

# https://github.com/rails/rails/issues/22965
#
# source://shimmer//lib/shimmer/version.rb#3
module Shimmer; end

# source://shimmer//lib/shimmer/auth.rb#4
module Shimmer::Auth; end

# source://shimmer//lib/shimmer/auth/apple_provider.rb#5
class Shimmer::Auth::AppleProvider < ::Shimmer::Auth::Provider
  private

  # @raise [InvalidTokenError]
  #
  # source://shimmer//lib/shimmer/auth/apple_provider.rb#10
  def request_details(params); end
end

# source://shimmer//lib/shimmer/auth/authenticating.rb#5
module Shimmer::Auth::Authenticating
  extend ::ActiveSupport::Concern
end

# source://shimmer//lib/shimmer/auth/current.rb#5
module Shimmer::Auth::Current
  extend ::ActiveSupport::Concern
end

# source://shimmer//lib/shimmer/auth/dev_provider.rb#5
class Shimmer::Auth::DevProvider < ::Shimmer::Auth::Provider
  # source://shimmer//lib/shimmer/auth/dev_provider.rb#6
  def login(email:, user_agent: T.unsafe(nil), ip: T.unsafe(nil)); end
end

# source://shimmer//lib/shimmer/auth/device.rb#5
module Shimmer::Auth::Device
  extend ::ActiveSupport::Concern
end

# source://shimmer//lib/shimmer/auth/google_provider.rb#5
class Shimmer::Auth::GoogleProvider < ::Shimmer::Auth::Provider
  private

  # source://shimmer//lib/shimmer/auth/google_provider.rb#10
  def request_details(params); end
end

# source://shimmer//lib/shimmer/auth.rb#5
class Shimmer::Auth::Provider
  # @return [Provider] a new instance of Provider
  #
  # source://shimmer//lib/shimmer/auth.rb#11
  def initialize(model); end

  # source://shimmer//lib/shimmer/auth.rb#20
  def create_device(user:, user_agent: T.unsafe(nil), ip: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/auth.rb#15
  def login(params:, user_agent: T.unsafe(nil), ip: T.unsafe(nil)); end

  # Returns the value of attribute model.
  #
  # source://shimmer//lib/shimmer/auth.rb#8
  def model; end

  # source://shimmer//lib/shimmer/auth.rb#9
  def token_column; end

  # source://shimmer//lib/shimmer/auth.rb#9
  def token_column=(val); end

  private

  # source://shimmer//lib/shimmer/auth.rb#34
  def fetch_user(details); end

  # source://shimmer//lib/shimmer/auth.rb#28
  def log_login(user, device_id:, user_agent: T.unsafe(nil), ip: T.unsafe(nil)); end

  class << self
    # source://shimmer//lib/shimmer/auth.rb#9
    def token_column; end

    # source://shimmer//lib/shimmer/auth.rb#9
    def token_column=(val); end
  end
end

# source://shimmer//lib/shimmer/auth.rb#6
class Shimmer::Auth::Provider::InvalidTokenError < ::StandardError; end

# source://shimmer//lib/shimmer/auth.rb#7
class Shimmer::Auth::Provider::UserDetails < ::Struct
  # Returns the value of attribute email
  #
  # @return [Object] the current value of email
  def email; end

  # Sets the attribute email
  #
  # @param value [Object] the value to set the attribute email to.
  # @return [Object] the newly set value
  def email=(_); end

  # Returns the value of attribute first_name
  #
  # @return [Object] the current value of first_name
  def first_name; end

  # Sets the attribute first_name
  #
  # @param value [Object] the value to set the attribute first_name to.
  # @return [Object] the newly set value
  def first_name=(_); end

  # Returns the value of attribute last_name
  #
  # @return [Object] the current value of last_name
  def last_name; end

  # Sets the attribute last_name
  #
  # @param value [Object] the value to set the attribute last_name to.
  # @return [Object] the newly set value
  def last_name=(_); end

  # Returns the value of attribute token
  #
  # @return [Object] the current value of token
  def token; end

  # Sets the attribute token
  #
  # @param value [Object] the value to set the attribute token to.
  # @return [Object] the newly set value
  def token=(_); end

  class << self
    def [](*_arg0); end
    def inspect; end
    def keyword_init?; end
    def members; end
    def new(*_arg0); end
  end
end

# source://shimmer//lib/shimmer/auth/user.rb#5
module Shimmer::Auth::User
  extend ::ActiveSupport::Concern

  mixes_in_class_methods ::Shimmer::Auth::User::ClassMethods
end

# source://shimmer//lib/shimmer/auth/user.rb#0
module Shimmer::Auth::User::ClassMethods
  # source://shimmer//lib/shimmer/auth/user.rb#15
  def login!(provider:, **attributes); end
end

# source://shimmer//lib/shimmer/middlewares/cloudflare.rb#5
class Shimmer::CloudflareProxy
  # @return [CloudflareProxy] a new instance of CloudflareProxy
  #
  # source://shimmer//lib/shimmer/middlewares/cloudflare.rb#6
  def initialize(app); end

  # source://shimmer//lib/shimmer/middlewares/cloudflare.rb#10
  def call(env); end
end

# source://shimmer//lib/shimmer/utils/config.rb#4
class Shimmer::Config
  include ::Singleton
  extend ::Singleton::SingletonClassMethods

  # @raise [ArgumentError]
  #
  # source://shimmer//lib/shimmer/utils/config.rb#9
  def method_missing(method_name, **options); end

  private

  # source://shimmer//lib/shimmer/utils/config.rb#33
  def coerce(value, type); end

  # @return [Boolean]
  #
  # source://shimmer//lib/shimmer/utils/config.rb#27
  def respond_to_missing?(method_name); end
end

# source://shimmer//lib/shimmer/utils/config.rb#7
class Shimmer::Config::MissingConfigError < ::StandardError; end

# source://shimmer//lib/shimmer/utils/consent_settings.rb#31
module Shimmer::Consent
  extend ::ActiveSupport::Concern
end

# source://shimmer//lib/shimmer/utils/consent_settings.rb#4
class Shimmer::ConsentSettings
  # @return [ConsentSettings] a new instance of ConsentSettings
  #
  # source://shimmer//lib/shimmer/utils/consent_settings.rb#13
  def initialize(cookies); end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def essential; end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def essential=(_arg0); end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def essential?; end

  # @return [Boolean]
  #
  # source://shimmer//lib/shimmer/utils/consent_settings.rb#26
  def given?; end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#21
  def save; end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def statistic; end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def statistic=(_arg0); end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def statistic?; end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def targeting; end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def targeting=(_arg0); end

  # source://shimmer//lib/shimmer/utils/consent_settings.rb#9
  def targeting?; end
end

# source://shimmer//lib/shimmer/utils/consent_settings.rb#6
Shimmer::ConsentSettings::DEFAULT = T.let(T.unsafe(nil), Array)

# source://shimmer//lib/shimmer/utils/consent_settings.rb#5
Shimmer::ConsentSettings::SETTINGS = T.let(T.unsafe(nil), Array)

# source://shimmer//lib/shimmer.rb#13
class Shimmer::Error < ::StandardError; end

# source://shimmer//lib/shimmer/utils/file_helper.rb#14
module Shimmer::FileAdditions
  # source://shimmer//lib/shimmer/utils/file_helper.rb#29
  def image_file_path(source, width: T.unsafe(nil), height: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/file_helper.rb#37
  def image_file_proxy(source, width: T.unsafe(nil), height: T.unsafe(nil), return_type: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/file_helper.rb#33
  def image_file_url(source, width: T.unsafe(nil), height: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/file_helper.rb#15
  def image_tag(source, **options); end
end

# source://shimmer//lib/shimmer/utils/file_helper.rb#4
module Shimmer::FileHelper
  extend ::ActiveSupport::Concern
end

# source://shimmer//lib/shimmer/utils/file_proxy.rb#4
class Shimmer::FileProxy
  # @return [FileProxy] a new instance of FileProxy
  #
  # source://shimmer//lib/shimmer/utils/file_proxy.rb#17
  def initialize(blob_id:, resize: T.unsafe(nil), width: T.unsafe(nil), height: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#43
  def blob; end

  # Returns the value of attribute blob_id.
  #
  # source://shimmer//lib/shimmer/utils/file_proxy.rb#5
  def blob_id; end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#8
  def content_type(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#55
  def file; end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#8
  def filename(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#7
  def message_verifier(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#35
  def path; end

  # Returns the value of attribute resize.
  #
  # source://shimmer//lib/shimmer/utils/file_proxy.rb#5
  def resize; end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#47
  def resizeable; end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#39
  def url(protocol: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#51
  def variant; end

  private

  # source://shimmer//lib/shimmer/utils/file_proxy.rb#61
  def id; end

  class << self
    # source://shimmer//lib/shimmer/utils/file_proxy.rb#30
    def message_verifier; end

    # source://shimmer//lib/shimmer/utils/file_proxy.rb#11
    def restore(id); end
  end
end

# source://shimmer//lib/shimmer/controllers/files_controller.rb#4
class Shimmer::FilesController < ::ActionController::Base
  # source://shimmer//lib/shimmer/controllers/files_controller.rb#5
  def show; end

  private

  # source://actionview/7.0.4.3/lib/action_view/layouts.rb#328
  def _layout(lookup_context, formats); end

  class << self
    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
    def __callbacks; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal.rb#210
    def middleware_stack; end
  end
end

# source://shimmer//lib/shimmer/form.rb#4
module Shimmer::Form; end

# source://shimmer//lib/shimmer/form/builder.rb#5
class Shimmer::Form::Builder < ::ActionView::Helpers::FormBuilder
  # source://shimmer//lib/shimmer/form/builder.rb#88
  def content_tag(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/form/builder.rb#88
  def icon(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/form/builder.rb#16
  def input(method, as: T.unsafe(nil), wrapper_options: T.unsafe(nil), description: T.unsafe(nil), label_method: T.unsafe(nil), id_method: T.unsafe(nil), name_method: T.unsafe(nil), label: T.unsafe(nil), **options); end

  # source://shimmer//lib/shimmer/form/builder.rb#88
  def safe_join(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/form/builder.rb#88
  def t(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/form/builder.rb#88
  def tag(*_arg0, **_arg1, &_arg2); end

  private

  # source://shimmer//lib/shimmer/form/builder.rb#61
  def association_for(method); end

  # source://shimmer//lib/shimmer/form/builder.rb#66
  def enum_for(method); end

  # source://shimmer//lib/shimmer/form/builder.rb#48
  def guess_collection(method); end

  # source://shimmer//lib/shimmer/form/builder.rb#52
  def guess_name_method(method); end

  # source://shimmer//lib/shimmer/form/builder.rb#44
  def guess_type(method); end

  # source://shimmer//lib/shimmer/form/builder.rb#80
  def helper; end

  # source://shimmer//lib/shimmer/form/builder.rb#40
  def required_attributes; end

  # source://shimmer//lib/shimmer/form/builder.rb#84
  def value_for(method); end

  # source://shimmer//lib/shimmer/form/builder.rb#70
  def wrap(method:, content:, classes:, label:, data: T.unsafe(nil), extra: T.unsafe(nil), description: T.unsafe(nil), options: T.unsafe(nil), label_method: T.unsafe(nil)); end

  class << self
    # source://shimmer//lib/shimmer/form/builder.rb#7
    def input_registry; end

    # source://shimmer//lib/shimmer/form/builder.rb#11
    def register(klass); end
  end
end

# source://shimmer//lib/shimmer/form/checkbox_field.rb#5
class Shimmer::Form::CheckboxField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/checkbox_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/checkboxes_field.rb#5
class Shimmer::Form::CheckboxesField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/checkboxes_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/date_field.rb#5
class Shimmer::Form::DateField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/date_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/datetime_field.rb#5
class Shimmer::Form::DatetimeField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/datetime_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/email_field.rb#5
class Shimmer::Form::EmailField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/email_field.rb#14
  def render; end

  class << self
    # @return [Boolean]
    #
    # source://shimmer//lib/shimmer/form/email_field.rb#9
    def can_handle?(method); end

    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/field.rb#5
class Shimmer::Form::Field
  # @return [Field] a new instance of Field
  #
  # source://shimmer//lib/shimmer/form/field.rb#23
  def initialize(builder:, method:, collection:, id_method:, name_method:, options: T.unsafe(nil)); end

  # Returns the value of attribute builder.
  #
  # source://shimmer//lib/shimmer/form/field.rb#8
  def builder; end

  # Returns the value of attribute collection.
  #
  # source://shimmer//lib/shimmer/form/field.rb#8
  def collection; end

  # Returns the value of attribute id_method.
  #
  # source://shimmer//lib/shimmer/form/field.rb#8
  def id_method; end

  # Returns the value of attribute method.
  #
  # source://shimmer//lib/shimmer/form/field.rb#8
  def method; end

  # Returns the value of attribute name_method.
  #
  # source://shimmer//lib/shimmer/form/field.rb#8
  def name_method; end

  # Returns the value of attribute options.
  #
  # source://shimmer//lib/shimmer/form/field.rb#8
  def options; end

  # source://shimmer//lib/shimmer/form/field.rb#20
  def prepare; end

  # source://shimmer//lib/shimmer/form/field.rb#6
  def type; end

  # source://shimmer//lib/shimmer/form/field.rb#6
  def type=(_arg0); end

  # source://shimmer//lib/shimmer/form/field.rb#6
  def type?; end

  # source://shimmer//lib/shimmer/form/field.rb#16
  def wrapper_options; end

  class << self
    # @return [Boolean]
    #
    # source://shimmer//lib/shimmer/form/field.rb#11
    def can_handle?(method); end

    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end

    # source://shimmer//lib/shimmer/form/field.rb#6
    def type=(value); end

    # source://shimmer//lib/shimmer/form/field.rb#6
    def type?; end
  end
end

# source://shimmer//lib/shimmer/form/image_field.rb#5
class Shimmer::Form::ImageField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/image_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/number_field.rb#5
class Shimmer::Form::NumberField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/number_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/password_field.rb#5
class Shimmer::Form::PasswordField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/password_field.rb#14
  def render; end

  class << self
    # @return [Boolean]
    #
    # source://shimmer//lib/shimmer/form/password_field.rb#9
    def can_handle?(method); end

    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/pdf_field.rb#5
class Shimmer::Form::PdfField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/pdf_field.rb#14
  def render; end

  class << self
    # @return [Boolean]
    #
    # source://shimmer//lib/shimmer/form/pdf_field.rb#9
    def can_handle?(method); end

    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/radio_field.rb#5
class Shimmer::Form::RadioField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/radio_field.rb#8
  def prepare; end

  # source://shimmer//lib/shimmer/form/radio_field.rb#12
  def render; end

  # source://shimmer//lib/shimmer/form/radio_field.rb#16
  def wrapper_options; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/radios_field.rb#5
class Shimmer::Form::RadiosField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/radios_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/select_field.rb#5
class Shimmer::Form::SelectField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/select_field.rb#14
  def render; end

  class << self
    # @return [Boolean]
    #
    # source://shimmer//lib/shimmer/form/select_field.rb#9
    def can_handle?(method); end

    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/text_area_field.rb#5
class Shimmer::Form::TextAreaField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/text_area_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/text_field.rb#5
class Shimmer::Form::TextField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/text_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/form/time_field.rb#5
class Shimmer::Form::TimeField < ::Shimmer::Form::Field
  # source://shimmer//lib/shimmer/form/time_field.rb#8
  def render; end

  class << self
    # source://shimmer//lib/shimmer/form/field.rb#6
    def type; end
  end
end

# source://shimmer//lib/shimmer/utils/localizable.rb#4
module Shimmer::Localizable
  extend ::ActiveSupport::Concern
end

# source://shimmer//lib/shimmer/utils/meta.rb#4
class Shimmer::Meta
  # source://shimmer//lib/shimmer/utils/meta.rb#5
  def app_name; end

  # source://shimmer//lib/shimmer/utils/meta.rb#5
  def app_name=(_arg0); end

  # source://shimmer//lib/shimmer/utils/meta.rb#5
  def app_name?; end

  # Returns the value of attribute canonical.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def canonical; end

  # Sets the attribute canonical
  #
  # @param value the value to set the attribute canonical to.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def canonical=(_arg0); end

  # Returns the value of attribute description.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def description; end

  # Sets the attribute description
  #
  # @param value the value to set the attribute description to.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def description=(_arg0); end

  # Returns the value of attribute image.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def image; end

  # Sets the attribute image
  #
  # @param value the value to set the attribute image to.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def image=(_arg0); end

  # source://shimmer//lib/shimmer/utils/meta.rb#8
  def tags; end

  # Returns the value of attribute title.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def title; end

  # Sets the attribute title
  #
  # @param value the value to set the attribute title to.
  #
  # source://shimmer//lib/shimmer/utils/meta.rb#6
  def title=(_arg0); end

  class << self
    # source://shimmer//lib/shimmer/utils/meta.rb#5
    def app_name; end

    # source://shimmer//lib/shimmer/utils/meta.rb#5
    def app_name=(value); end

    # source://shimmer//lib/shimmer/utils/meta.rb#5
    def app_name?; end
  end
end

# source://shimmer//lib/shimmer/helpers/meta_helper.rb#4
module Shimmer::MetaHelper
  # source://shimmer//lib/shimmer/helpers/meta_helper.rb#15
  def description(value); end

  # source://shimmer//lib/shimmer/helpers/meta_helper.rb#19
  def image(value); end

  # source://shimmer//lib/shimmer/helpers/meta_helper.rb#5
  def meta; end

  # source://shimmer//lib/shimmer/helpers/meta_helper.rb#23
  def render_meta; end

  # source://shimmer//lib/shimmer/helpers/meta_helper.rb#11
  def title(value); end
end

# source://shimmer//lib/shimmer/railtie.rb#4
class Shimmer::Railtie < ::Rails::Railtie; end

# source://shimmer//lib/shimmer/utils/remote_navigation.rb#4
module Shimmer::RemoteNavigation
  extend ::ActiveSupport::Concern
end

# source://shimmer//lib/shimmer/utils/remote_navigation.rb#53
class Shimmer::RemoteNavigator
  # @return [RemoteNavigator] a new instance of RemoteNavigator
  #
  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#56
  def initialize(controller); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#72
  def append(id, with:, **locals); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#104
  def close_modal(id = T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#116
  def close_popover; end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#96
  def insert_after(id, with:, **locals); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#92
  def insert_before(id, with:, **locals); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#120
  def navigate_to(path); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#100
  def open_modal(url, id: T.unsafe(nil), size: T.unsafe(nil), close: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#112
  def open_popover(url, selector:, placement: T.unsafe(nil)); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#54
  def polymorphic_path(*_arg0, **_arg1, &_arg2); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#76
  def prepend(id, with:, **locals); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#60
  def queued_updates; end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#88
  def remove(id); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#80
  def replace(id, with: T.unsafe(nil), **locals); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#68
  def run_javascript(script); end

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#84
  def update(id, with: T.unsafe(nil), **locals); end

  # @return [Boolean]
  #
  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#64
  def updates?; end

  private

  # source://shimmer//lib/shimmer/utils/remote_navigation.rb#128
  def turbo_stream; end
end

# source://shimmer//lib/shimmer/utils/sitemap_adapter.rb#4
class Shimmer::SitemapAdapter
  # source://shimmer//lib/shimmer/utils/sitemap_adapter.rb#5
  def write(location, raw_data); end
end

# source://shimmer//lib/shimmer/jobs/sitemap_job.rb#4
class Shimmer::SitemapJob < ::ActiveJob::Base
  # source://shimmer//lib/shimmer/jobs/sitemap_job.rb#5
  def perform; end
end

# source://shimmer//lib/shimmer/controllers/sitemaps_controller.rb#4
class Shimmer::SitemapsController < ::ActionController::Base
  # source://shimmer//lib/shimmer/controllers/sitemaps_controller.rb#5
  def show; end

  private

  # source://actionview/7.0.4.3/lib/action_view/layouts.rb#328
  def _layout(lookup_context, formats); end

  class << self
    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
    def __callbacks; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal.rb#210
    def middleware_stack; end
  end
end

# source://shimmer//lib/shimmer/version.rb#4
Shimmer::VERSION = T.let(T.unsafe(nil), String)