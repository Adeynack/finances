# Import from Moneydance

## Example Call

```sh
ruby scripts/import/moneydance/import.rb \
  --input-file tmp/moneydance.json \
  --default-currency eur \
  --delete-book \
  --api-url "http://localhost:30001/graphql" \
  --api-email "joe@example.com" \
  --api-password "joe"
```
