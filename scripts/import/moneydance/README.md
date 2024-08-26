# Import from Moneydance

## Example Call

```sh
ruby scripts/import/moneydance/import.rb \
  --input-file moneydance.json \
  --default-currency eur \
  --delete-book \
  --api-url "https://finances.example.com/graphql" \
  --api-email "user@example.com" \
  --api-password "password"
```
