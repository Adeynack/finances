# frozen_string_literal: true

module Import::Moneydance::ExchangeImport
  private

  def import_exchanges
    logger.info "Importing exchanges (MD transactions)"
    total = md_items_by_type["txn"].count
    ordered_md_transactions = md_items_by_type["txn"].sort_by { |t| t["dtentered"] }
    ordered_md_transactions.each_with_index do |md_transaction, index|
      number = index + 1
      percent = (number.to_f / total * 100).floor
      logger.info "[#{number}/#{total} (#{percent}%)] Importing transaction #{md_transaction["id"]}"
      import_transaction(md_transaction)
    end
  end

  def import_transaction(md_transaction)
    exchange = Exchange.create!(
      created_at: from_md_unix_date(md_transaction["dtentered"]),
      date: from_md_int_date(md_transaction["dt"]),
      register_id: register_id_by_md_acctid[md_transaction["acctid"]],
      cheque: md_transaction["chk"].presence,
      description: md_transaction["desc"].presence,
      memo: md_transaction["memo"].presence,
      status: from_md_stat(md_transaction["stat"])
    )
    exchange.import_origins.create! external_system: "moneydance", external_id: md_transaction["id"]
    import_splits(md_transaction, exchange)
  end

  def from_md_stat(md_stat)
    case md_stat.presence
    when nil then "uncleared"
    when "X" then "cleared"
    when "x" then "reconciling"
    else raise(ArgumentError, "unknown transaction stat '#{md_stat}'")
    end
  end

  def import_splits(md_transaction, exchange)
    md_splits_per_index = extract_md_splits(md_transaction)
    md_splits_per_index.keys.sort.each do |md_split_index|
      md_split = md_splits_per_index[md_split_index]
      import_split(md_split, exchange)
    end
  end

  def extract_md_splits(md_transaction)
    md_splits_per_index = {}
    md_transaction.each do |key, value|
      key_parts = key.split(".")
      next unless key_parts.length == 2

      split_index = key_parts.first.to_i
      split_attribute = key_parts[1..].join(".")
      md_split = md_splits_per_index[split_index] ||= {}
      md_split[split_attribute] = value
    end
    md_splits_per_index
  end

  def import_split(md_split, exchange)
    split = exchange.splits.create!(
      created_at: exchange.created_at,
      register_id: register_id_by_md_acctid[md_split["acctid"]],
      amount: md_split["samt"].to_i,
      counterpart_amount: md_split["pamt"].to_i,
      memo: md_split["desc"].presence,
      status: from_md_stat(md_split["stat"])
    )
    md_split.fetch("tags", "").split("\t").each { |tag_name| split.tag tag_name }
    split.import_origins.create! external_system: "moneydance", external_id: md_split["id"]
  end
end
