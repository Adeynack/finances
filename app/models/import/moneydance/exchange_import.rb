# frozen_string_literal: true
# typed: strict

module Import::Moneydance
  class ExchangeImport
    extend T::Sig
    include Import::Moneydance::Utils

    sig {
      params(
        logger: Logger,
        md_items_by_type: T::Hash[String, T::Array[StringHash]],
        register_id_by_md_acctid: T::Hash[String, String]
      ).void
    }
    def initialize(logger:, md_items_by_type:, register_id_by_md_acctid:)
      @logger = logger
      @md_items_by_type = md_items_by_type
      @register_id_by_md_acctid = register_id_by_md_acctid
    end

    sig { void }
    def import_exchanges
      @logger.info "Importing exchanges (MD transactions)"
      txn_items = @md_items_by_type["txn"].to_a
      total = txn_items.count
      ordered_md_transactions = txn_items.sort_by { |t| t.fetch("dtentered") }
      ordered_md_transactions.each_with_index do |md_transaction, index|
        number = index + 1
        percent = (number.to_f / total * 100).floor
        @logger.info "[#{number}/#{total} (#{percent}%)] Importing transaction #{md_transaction["id"]}"
        import_transaction(md_transaction)
      end
    end

    private

    sig { params(md_transaction: StringHash).void }
    def import_transaction(md_transaction)
      exchange = Exchange.create!(
        created_at: from_md_unix_date(md_transaction["dtentered"]),
        date: from_md_int_date(md_transaction["dt"]),
        register_id: @register_id_by_md_acctid[md_transaction.fetch("acctid")],
        cheque: md_transaction["chk"].presence,
        description: md_transaction["desc"].presence,
        memo: md_transaction["memo"].presence,
        status: from_md_stat(md_transaction["stat"])
      )
      exchange.import_origins.create! external_system: "moneydance", external_id: md_transaction["id"]
      import_splits(md_transaction, exchange)
    end

    sig { params(md_transaction: StringHash, exchange: Exchange).void }
    def import_splits(md_transaction, exchange)
      md_splits_per_index = extract_md_splits(md_transaction)
      md_splits_per_index.keys.sort.each do |md_split_index|
        md_split = md_splits_per_index[md_split_index]
        import_split(md_split, exchange) if md_split
      end
    end

    sig { params(md_transaction: StringHash).returns(T::Hash[Integer, StringHash]) }
    def extract_md_splits(md_transaction)
      md_splits_per_index = {}
      md_transaction.each do |key, value|
        key_parts = key.split(".")
        next unless key_parts.length == 2

        split_index = key_parts.first.to_i
        split_attribute = key_parts[1..].to_a.join(".")
        md_split = md_splits_per_index[split_index] ||= {}
        md_split[split_attribute] = value
      end
      md_splits_per_index
    end

    sig { params(md_split: StringHash, exchange: Exchange).void }
    def import_split(md_split, exchange)
      split = exchange.splits.create!(
        created_at: exchange.created_at,
        register_id: @register_id_by_md_acctid[md_split.fetch("acctid")],
        amount: md_split["samt"].to_i,
        counterpart_amount: md_split["pamt"].to_i,
        memo: md_split["desc"].presence,
        status: from_md_stat(md_split["stat"])
      )
      md_split["tags"].to_s.split("\t").each { |tag_name| split.tag tag_name }
      split.import_origins.create! external_system: "moneydance", external_id: md_split["id"]
    end
  end
end
