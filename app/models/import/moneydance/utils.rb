# frozen_string_literal: true
# typed: strict

module Import::Moneydance::Utils
  extend T::Sig
  include Kernel

  StringHash = T.type_alias { T::Hash[String, String] } # rubocop:disable Naming/MutableConstant

  sig { params(exp_year: T.nilable(String), exp_month: T.nilable(String)).returns(T.nilable(Date)) }
  def expiry_date(exp_year, exp_month)
    return nil if exp_year.blank?

    year = exp_year.to_i
    month = exp_month.presence&.to_i || 1
    Date.new(year, month, 1)
  end

  sig { params(md_date: T.nilable(String), default: T.nilable(Date)).returns(T.nilable(Date)) }
  def from_md_unix_date(md_date, default = nil)
    return default if md_date.blank?

    DateTime.strptime(md_date, "%Q")
  end

  sig { params(md_date: T.nilable(String), default: T.nilable(Date)).returns(T.nilable(Date)) }
  def from_md_int_date(md_date, default = nil)
    return default if md_date.blank?
    return nil if md_date == "0"

    md_date = md_date.to_s
    raise ArgumentError, "expecting a 8 digits number" unless md_date.length == 8

    DateTime.parse(md_date)
  end

  sig { params(md_stat: T.nilable(String)).returns(String) }
  def from_md_stat(md_stat)
    case md_stat.presence
    when nil then "uncleared"
    when "X" then "cleared"
    when "x" then "reconciling"
    else raise(ArgumentError, "unknown transaction stat '#{md_stat}'")
    end
  end
end
