# frozen_string_literal: true

require_relative "utils"

module MoneydanceImport
  class ExchangeImport
    include MoneydanceImport::Utils

    def initialize(create_progress_bar:, api_client:, book:, md_items_by_type:, register_id_by_md_acctid:)
      @create_progress_bar = create_progress_bar
      @api_client = api_client
      @book = book
      @md_items_by_type = md_items_by_type
      @register_id_by_md_acctid = register_id_by_md_acctid
    end

    def import_exchanges
      puts "Importing exchanges (MD transactions)"
      txn_items = @md_items_by_type["txn"].to_a
      bar = @create_progress_bar.call(title: "Importing exchanges (transactions)", total: txn_items.size)
      @api_client.bar = bar

      ordered_md_transactions = txn_items.sort_by { |t| t.fetch("dtentered") }
      ordered_md_transactions.each_with_index do |md_transaction, index|
        bar.log "Import exchange on #{from_md_unix_date(md_transaction["dtentered"]).to_date} '#{md_transaction["desc"]}' (#{md_transaction["id"]})"
        import_transaction(md_transaction:)
        bar.increment
      end
    ensure
      @api_client.bar = nil
    end

    private

    def import_transaction(md_transaction:)
      exchange = {
        import_origin: {system: "moneydance", id: md_transaction["id"]},
        created_at: from_md_unix_date(md_transaction["dtentered"]),
        date: from_md_int_date(md_transaction["dt"]),
        register_id: @register_id_by_md_acctid[md_transaction.fetch("acctid")],
        cheque: md_transaction["chk"].presence,
        description: md_transaction["desc"].presence,
        memo: md_transaction["memo"].presence,
        status: from_md_stat(md_transaction["stat"]),
        splits: extract_md_splits(md_transaction:)
      }
      @api_client.create_exchange(exchange:)
    end

    def extract_md_splits(md_transaction:)
      md_splits_per_index = {}
      md_transaction.each do |key, value|
        key_parts = key.split(".")
        next unless key_parts.length == 2

        split_index = key_parts.first.to_i
        split_attribute = key_parts.drop(1).to_a.join(".")
        md_split = md_splits_per_index[split_index] ||= {}
        md_split[split_attribute] = value
      end

      md_splits = md_splits_per_index.keys.sort.map! { |i| md_splits_per_index.fetch(i) }
      md_splits.map do |md_split|
        {
          import_origin: {system: "moneydance", id: md_split["id"]},
          register_id: @register_id_by_md_acctid[md_split.fetch("acctid")],
          amount: md_split["samt"].to_i,
          counterpart_amount: md_split["pamt"].to_i,
          memo: md_split["desc"].presence,
          status: from_md_stat(md_split["stat"]),
          tags: md_split["tags"].to_s.split("\t")
        }
      end
    end
  end
end
