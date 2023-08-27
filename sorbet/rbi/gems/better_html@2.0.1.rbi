# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `better_html` gem.
# Please instead update this file by running `bin/tapioca gem better_html`.

# source://better_html//lib/better_html/errors.rb#6
module BetterHtml; end

# source://better_html//lib/better_html/ast/iterator.rb#7
module BetterHtml::AST; end

# source://better_html//lib/better_html/ast/iterator.rb#8
class BetterHtml::AST::Iterator
  # @return [Iterator] a new instance of Iterator
  #
  # source://better_html//lib/better_html/ast/iterator.rb#18
  def initialize(types, &block); end

  # source://better_html//lib/better_html/ast/iterator.rb#23
  def traverse(node); end

  # source://better_html//lib/better_html/ast/iterator.rb#30
  def traverse_all(nodes); end

  class << self
    # source://better_html//lib/better_html/ast/iterator.rb#10
    def descendants(root_node, type); end
  end
end

# source://better_html//lib/better_html/ast/node.rb#8
class BetterHtml::AST::Node < ::AST::Node
  # source://better_html//lib/better_html/ast/node.rb#11
  def descendants(*types); end

  # Returns the value of attribute loc.
  #
  # source://better_html//lib/better_html/ast/node.rb#9
  def loc; end

  # source://better_html//lib/better_html/ast/node.rb#15
  def location; end
end

# source://better_html//lib/better_html/errors.rb#8
class BetterHtml::DontInterpolateHere < ::BetterHtml::InterpolatorError; end

# source://better_html//lib/better_html/errors.rb#12
class BetterHtml::Errors < ::Array
  def add(_arg0); end
end

# source://better_html//lib/better_html/errors.rb#10
class BetterHtml::HtmlError < ::RuntimeError; end

# source://better_html//lib/better_html/errors.rb#7
class BetterHtml::InterpolatorError < ::RuntimeError; end

# source://better_html//lib/better_html/parser.rb#13
class BetterHtml::Parser
  # @raise [ArgumentError]
  # @return [Parser] a new instance of Parser
  #
  # source://better_html//lib/better_html/parser.rb#26
  def initialize(buffer, template_language: T.unsafe(nil)); end

  # source://better_html//lib/better_html/parser.rb#48
  def ast; end

  # source://better_html//lib/better_html/parser.rb#61
  def inspect; end

  # source://better_html//lib/better_html/parser.rb#43
  def nodes_with_type(*type); end

  # source://better_html//lib/better_html/parser.rb#52
  def parser_errors; end

  # Returns the value of attribute template_language.
  #
  # source://better_html//lib/better_html/parser.rb#14
  def template_language; end

  private

  # source://better_html//lib/better_html/parser.rb#180
  def build_attribute_name_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#170
  def build_attribute_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#185
  def build_attribute_value_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#115
  def build_cdata_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#120
  def build_comment_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#69
  def build_document_node; end

  # source://better_html//lib/better_html/parser.rb#91
  def build_erb_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#245
  def build_interpolation_node(tokens); end

  # @raise [ArgumentError]
  #
  # source://better_html//lib/better_html/parser.rb#206
  def build_location(enumerable); end

  # source://better_html//lib/better_html/parser.rb#104
  def build_lodash_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#165
  def build_nameless_attribute_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#198
  def build_node(type, tokens, pre: T.unsafe(nil), post: T.unsafe(nil)); end

  # source://better_html//lib/better_html/parser.rb#145
  def build_tag_attributes_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#140
  def build_tag_name_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#125
  def build_tag_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#193
  def build_text_node(tokens); end

  # source://better_html//lib/better_html/parser.rb#213
  def empty_location; end

  # source://better_html//lib/better_html/parser.rb#217
  def shift_all(tokens, *types); end

  # source://better_html//lib/better_html/parser.rb#255
  def shift_all_with_interpolation(tokens, *types); end

  # source://better_html//lib/better_html/parser.rb#280
  def shift_between(tokens, start_type, end_type); end

  # source://better_html//lib/better_html/parser.rb#288
  def shift_between_with_interpolation(tokens, start_type, end_type); end

  # source://better_html//lib/better_html/parser.rb#229
  def shift_single(tokens, *types); end

  # source://better_html//lib/better_html/parser.rb#233
  def shift_until(tokens, *types); end

  # source://better_html//lib/better_html/parser.rb#268
  def shift_until_with_interpolation(tokens, *types); end

  # source://better_html//lib/better_html/parser.rb#296
  def wrap_token(object); end

  # source://better_html//lib/better_html/parser.rb#313
  def wrap_tokens(enumerable); end
end

# source://better_html//lib/better_html/parser.rb#16
class BetterHtml::Parser::Error < ::BetterHtml::HtmlError
  # @return [Error] a new instance of Error
  #
  # source://better_html//lib/better_html/parser.rb#20
  def initialize(message, location:); end

  # Returns the value of attribute location.
  #
  # source://better_html//lib/better_html/parser.rb#17
  def loc; end

  # Returns the value of attribute location.
  #
  # source://better_html//lib/better_html/parser.rb#17
  def location; end
end

# source://better_html//lib/better_html/parser.rb#67
BetterHtml::Parser::INTERPOLATION_TYPES = T.let(T.unsafe(nil), Array)

# source://better_html//lib/better_html/errors.rb#16
class BetterHtml::ParserError < ::RuntimeError
  # @return [ParserError] a new instance of ParserError
  #
  # source://better_html//lib/better_html/errors.rb#19
  def initialize(message, position, line, column); end

  # Returns the value of attribute column.
  #
  # source://better_html//lib/better_html/errors.rb#17
  def column; end

  # Returns the value of attribute line.
  #
  # source://better_html//lib/better_html/errors.rb#17
  def line; end

  # Returns the value of attribute position.
  #
  # source://better_html//lib/better_html/errors.rb#17
  def position; end
end

# source://better_html//lib/better_html/tokenizer/token.rb#4
module BetterHtml::Tokenizer; end

# source://better_html//lib/better_html/tokenizer/base_erb.rb#10
class BetterHtml::Tokenizer::BaseErb < ::Erubi::Engine
  # @raise [ArgumentError]
  # @return [BaseErb] a new instance of BaseErb
  #
  # source://better_html//lib/better_html/tokenizer/base_erb.rb#18
  def initialize(buffer); end

  # Returns the value of attribute current_position.
  #
  # source://better_html//lib/better_html/tokenizer/base_erb.rb#16
  def current_position; end

  # Returns the value of attribute tokens.
  #
  # source://better_html//lib/better_html/tokenizer/base_erb.rb#15
  def tokens; end

  private

  # source://better_html//lib/better_html/tokenizer/base_erb.rb#34
  def add_code(code); end

  # source://better_html//lib/better_html/tokenizer/base_erb.rb#53
  def add_erb_tokens(ltrim, indicator, code, rtrim); end

  # source://better_html//lib/better_html/tokenizer/base_erb.rb#47
  def add_expression(indicator, code); end

  # source://better_html//lib/better_html/tokenizer/base_erb.rb#80
  def add_token(type, begin_pos, end_pos); end

  # source://better_html//lib/better_html/tokenizer/base_erb.rb#30
  def append(text); end
end

# source://better_html//lib/better_html/tokenizer/base_erb.rb#13
BetterHtml::Tokenizer::BaseErb::EXPR_TRIM_MATCHER = T.let(T.unsafe(nil), Regexp)

# source://better_html//lib/better_html/tokenizer/base_erb.rb#11
BetterHtml::Tokenizer::BaseErb::REGEXP_WITHOUT_TRIM = T.let(T.unsafe(nil), Regexp)

# source://better_html//lib/better_html/tokenizer/base_erb.rb#12
BetterHtml::Tokenizer::BaseErb::STMT_TRIM_MATCHER = T.let(T.unsafe(nil), Regexp)

# source://better_html//lib/better_html/tokenizer/html_erb.rb#7
class BetterHtml::Tokenizer::HtmlErb < ::BetterHtml::Tokenizer::BaseErb
  # @return [HtmlErb] a new instance of HtmlErb
  #
  # source://better_html//lib/better_html/tokenizer/html_erb.rb#10
  def initialize(buffer); end

  # source://better_html//lib/better_html/tokenizer/html_erb.rb#15
  def current_position; end

  # Returns the value of attribute parser.
  #
  # source://better_html//lib/better_html/tokenizer/html_erb.rb#8
  def parser; end

  private

  # source://better_html//lib/better_html/tokenizer/html_erb.rb#25
  def add_text(text); end

  # source://better_html//lib/better_html/tokenizer/html_erb.rb#21
  def append(text); end
end

# source://better_html//lib/better_html/tokenizer/html_lodash.rb#9
class BetterHtml::Tokenizer::HtmlLodash
  # @return [HtmlLodash] a new instance of HtmlLodash
  #
  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#18
  def initialize(buffer); end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
  def lodash_escape; end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
  def lodash_escape=(val); end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
  def lodash_evaluate; end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
  def lodash_evaluate=(val); end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
  def lodash_interpolate; end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
  def lodash_interpolate=(val); end

  # Returns the value of attribute parser.
  #
  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#11
  def parser; end

  # Returns the value of attribute tokens.
  #
  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#10
  def tokens; end

  private

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#79
  def add_lodash_tokens(indicator, code); end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#73
  def add_text(text); end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#96
  def add_token(type, begin_pos: T.unsafe(nil), end_pos: T.unsafe(nil)); end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#28
  def scan!; end

  # source://better_html//lib/better_html/tokenizer/html_lodash.rb#62
  def scan_pattern; end

  class << self
    # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
    def lodash_escape; end

    # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
    def lodash_escape=(val); end

    # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
    def lodash_evaluate; end

    # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
    def lodash_evaluate=(val); end

    # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
    def lodash_interpolate; end

    # source://better_html//lib/better_html/tokenizer/html_lodash.rb#13
    def lodash_interpolate=(val); end
  end
end

# source://better_html//lib/better_html/tokenizer/javascript_erb.rb#7
class BetterHtml::Tokenizer::JavascriptErb < ::BetterHtml::Tokenizer::BaseErb
  private

  # source://better_html//lib/better_html/tokenizer/javascript_erb.rb#10
  def add_text(text); end
end

# source://better_html//lib/better_html/tokenizer/location.rb#8
class BetterHtml::Tokenizer::Location < ::Parser::Source::Range
  # @raise [ArgumentError]
  # @return [Location] a new instance of Location
  #
  # source://better_html//lib/better_html/tokenizer/location.rb#9
  def initialize(buffer, begin_pos, end_pos); end

  # source://better_html//lib/better_html/tokenizer/location.rb#50
  def adjust(begin_pos: T.unsafe(nil), end_pos: T.unsafe(nil)); end

  # source://better_html//lib/better_html/tokenizer/location.rb#62
  def begin; end

  # source://better_html//lib/better_html/tokenizer/location.rb#66
  def end; end

  # source://better_html//lib/better_html/tokenizer/location.rb#30
  def line_range; end

  # source://better_html//lib/better_html/tokenizer/location.rb#39
  def line_source_with_underline; end

  # source://better_html//lib/better_html/tokenizer/location.rb#58
  def offset(offset); end

  # source://better_html//lib/better_html/tokenizer/location.rb#26
  def range; end

  # source://better_html//lib/better_html/tokenizer/location.rb#54
  def resize(new_size); end

  # source://parser/3.2.1.1/lib/parser/source/range.rb#92
  def start_column; end

  # source://parser/3.2.1.1/lib/parser/source/range.rb#83
  def start_line; end

  # source://parser/3.2.1.1/lib/parser/source/range.rb#106
  def stop_column; end

  # source://parser/3.2.1.1/lib/parser/source/range.rb#99
  def stop_line; end

  # source://better_html//lib/better_html/tokenizer/location.rb#46
  def with(begin_pos: T.unsafe(nil), end_pos: T.unsafe(nil)); end
end

# source://better_html//lib/better_html/tokenizer/token.rb#5
class BetterHtml::Tokenizer::Token
  # @return [Token] a new instance of Token
  #
  # source://better_html//lib/better_html/tokenizer/token.rb#8
  def initialize(type:, loc:); end

  # source://better_html//lib/better_html/tokenizer/token.rb#13
  def inspect; end

  # Returns the value of attribute loc.
  #
  # source://better_html//lib/better_html/tokenizer/token.rb#6
  def loc; end

  # Returns the value of attribute type.
  #
  # source://better_html//lib/better_html/tokenizer/token.rb#6
  def type; end
end

# source://better_html//lib/better_html/tokenizer/token_array.rb#5
class BetterHtml::Tokenizer::TokenArray
  # @return [TokenArray] a new instance of TokenArray
  #
  # source://better_html//lib/better_html/tokenizer/token_array.rb#6
  def initialize(list); end

  # @return [Boolean]
  #
  # source://better_html//lib/better_html/tokenizer/token_array.rb#37
  def any?; end

  # source://better_html//lib/better_html/tokenizer/token_array.rb#41
  def current; end

  # @return [Boolean]
  #
  # source://better_html//lib/better_html/tokenizer/token_array.rb#33
  def empty?; end

  # source://better_html//lib/better_html/tokenizer/token_array.rb#45
  def last; end

  # source://better_html//lib/better_html/tokenizer/token_array.rb#20
  def pop; end

  # source://better_html//lib/better_html/tokenizer/token_array.rb#12
  def shift; end

  # source://better_html//lib/better_html/tokenizer/token_array.rb#49
  def size; end

  # source://better_html//lib/better_html/tokenizer/token_array.rb#28
  def trim(type); end
end

# source://better_html//lib/better_html/errors.rb#9
class BetterHtml::UnsafeHtmlError < ::BetterHtml::InterpolatorError; end
