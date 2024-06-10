# Finances MVP (Most Valuable Product)

## Wording

The word _transaction_ got replaced by _exchange_, since _transaction_ is a reserved
word in _Rails_ and clashed with already generated methods. The word _transaction_ is
still used in this document.

## Goal

- [ ] Import, without any loss, the data from _Moneydance_ (actual finances application
      of the creator of this project).
- [ ] Perform day to day tasks actually performed by _Moneydance_ (being able to drop
      in the MVP and stop using _Moneydance_).

## Features required for the MVP

- [ ] Users
  - [ ] Manage through _ActiveAdmin_
  - [ ] Log In through _Devise_
- [ ] Books
  - [ ] CRUD
  - [ ] Delete only if no transaction
  - [ ] Chose current book (book to work in)
- [ ] Accounts
  - [ ] CRUD
  - [ ] Types:
    - [ ] Bank
    - [ ] Credit Card
    - [ ] Investment
    - [ ] Asset
    - [ ] Liability
    - [ ] Loan
  - [ ] Tree index of accounts
  - [ ] Delete only if no transaction
  - [ ] Only an account of the same type can be parent
- [ ] Categories
  - [ ] CRUD
  - [ ] Types:
    - [ ] Expense
    - [ ] Income
  - [ ] Tree index of categories
  - [ ] Delete only if no transaction
- [ ] Currencies
  - [ ] Anything supported by the money GEM (no CRUD), no custom currency at first.
- [ ] Transactions and their Splits
  - [ ] List transactions
    - [ ] for an accounts
    - [ ] for a category
  - [ ] Display balance on each line
  - [ ] Create a new transaction
    - [ ] Including a variable list of splits
  - [ ] Edit
  - [ ] Delete
- [ ] Reminders
  - [ ] Data Model only, no CRUD in MVP
- [ ] Import from MoneyDance
  - [ ] Import as new book or into existing book
  - [ ] Import Accounts
  - [ ] Import Categories
  - [ ] Import Transactions and their splits
  - [ ] Import Reminders
- [ ] Reminders
  - [ ] CRUD
  - [ ] Apply `auto_commit` reminders


## Model Requirements Brainstorm

### Accounts

| Attribute \ Type        | BASE   | META | Bank    | Credit Card | Investment | Asset | Liability | Loan      |
| ----------------------- | ------ | ---- | ------- | ----------- | ---------- | ----- | --------- | --------- |
| Account Name            | req    |      | x       | x           | x          | x     | x         | x         |
| Start Date              | req    |      | x       | x           | x          | x     | x         | x         |
| Currency                | req    |      | x       | x           | x          | x     | x         | x         |
| Default Category        | opt    |      | x       | x           | x          |       |           |           |
| Parent Account          | opt    |      | x       | x           |            | x     | x         | x         |
| Initial...              | `0`    |      | Balance | Debt        | Balance    | Value | Liability | Principal |
| Active                  | `true` |      | x       | x           | x          | x     | x         | x         |
| Comments (Notes)        | opt    |      | x       | x           | x          | x     | x         | x         |
| Website                 | opt    |      | x       | x           | x          |       |           |           |
| Bank Name (Group)       | opt    |      | x       | x           | x          |       |           |           |
| Account Number          |        | x    | x       |             | x          |       |           |           |
| Routing Number          |        | x    | -       |             |            |       |           |           |
| Check Numbers           |        | x    | -       | -           | -          | -     | -         |           |
| Card Number             |        | x    |         | x           |            |       |           |           |
| APR                     |        | x    |         | x           |            |       |           | -         |
| ... until               |        | x    |         | -           |            |       |           |           |
| ... then                |        | x    |         | -           |            |       |           |           |
| Credit Limit            |        | x    |         | x           |            |       |           |           |
| Payment Plan (type)     |        | x    |         | -           |            |       |           |           |
| Payment Plan (amount)   |        | x    |         | -           |            |       |           |           |
| Expires at              |        | x    |         | x           |            |       |           |           |
| Loan Points             |        | x    |         |             |            |       |           | -         |
| Payments per Year       |        | x    |         |             |            |       |           | -         |
| Number of Payments      |        | x    |         |             |            |       |           | -         |
| Interest Category       |        | x    |         |             |            |       |           | -         |
| Escrow Payment          |        | x    |         |             |            |       |           | -         |
| Escrow Account          |        | x    |         |             |            |       |           | -         |
| Specify Payment (or...) |        | x    |         |             |            |       |           | -         |
| Calculate Payment       |        | x    |         |             |            |       |           | -         |

### Categories

| Attribute \ Type | BASE    | Expense | Income |
| ---------------- | ------- | ------- | ------ |
| Name             | req     | x       | x      |
| Currency         | req     | x       | x      |
| Parent Category  | opt     | x       | x      |
| Tax Related      | `false` | -       | -      |
| Active           | `true`  | x       | x      |
| Comments         | opt     | x       | x      |

### Reminders

Focussing only on the _Transaction Reminders_, dropping the _General Reminder_ concept
of _Moneydance_.

| Attribute                          | BASE |
| ---------------------------------- | ---- |
| Description                        | req  |
| From                               | req  |
| To                                 | opt  |
| Period / Recurrence (TBD)          | req  |
| Auto-Commit (days before schedule) | opt  |
| Transaction Template               | req  |

### Transactions / Splits / Tags

#### Transactions

| Attribute        | BASE   |
| ---------------- | ------ |
| Account (Origin) | req fk |
| Date             | req    |
| Cheque           | opt    |
| Description      | req    |
| Memo             | opt    |
|                  |        |

#### Splits (Transaction Splits)

| Attribute                     | BASE                                | Example (single currency) | Example (multi curr.) |
| ----------------------------- | ----------------------------------- | ------------------------- | --------------------- |
| Transaction                   | req fk                              |                           |                       |
| Category                      | req fk                              |                           |                       |
| Amount (`0.samt`)             | req                                 | 120                       | 120                   |
| Counterpart Amount (`0.pamt`) | req                                 | -120                      | -95                   |
| Status                        | uncleared<br>reconciling<br>cleared |                           |                       |
| Memo                          | opt                                 |                           |                       |
| Tags                          | has_many                            |                           |                       |
|                               |                                     |                           |                       |

#### Tags (Transaction Split Tags)

| Attribute | BASE     |
| --------- | -------- |
| Name      | req      |
| Splits    | has_many |

## Misc Notes

### Convert from Epoch

In _Moneydance_, the `ts` field on transaction is specified in _Epoch_ (aka _Unix Time_).

```ruby
DateTime.strptime("1614116785891",'%Q')
```
