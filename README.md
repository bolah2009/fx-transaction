# AZA FX Transaction API

> A microservice to store FX transactions. This service stores how much money is received from customers in an input currency and how much that will be paid to the customer in the output currency.

## Technologies Used and Requirements

- Ruby (version 3.1.0)
- Bundler (version 2.3.7)
- Rails API for backend web service
- Rubocop for linting
- Prettier for formating
- [`heroku`](https://www.heroku.com/) for API deployment
- [`Swagger`](https://swagger.io/) for API documentation
- Rspec for testing

## Development (Running locally)

- Clone the project

```bash
git clone https://github.com/bolah2009/fx-transaction.git

```

- Install Dependencies

```bash
bundle install
```

- Run Migration with

```bash
bundle exec rails db:migrate
```

- Setup your database with:

```bash
bundle exec rails db:setup
# this command will create the database, load the schema, and initialize it with the seed data.
```

- Start the server using:

```bash
rails server
```

### Consuming the API locally

You can access the API using the Swagger UI, curl command (see example) or an API platform of your choice.

### Swagger UI

Visit the [Swagger UI API docs](http://localhost:800/api-docs) after running the server locally and choose the localhost option from the `Servers` dropdown.

### Curl

```bash
# POST /transactions
curl -X POST localhost:3000/transactions -d "{\"customer\":\"HnHei\",\"input_amount\":\"4032.02\",\"input_currency\":\"NGN\",\"output_amount\":\"34.21\",\"output_currency\":\"EUR\"}" -H "Content-Type: application/json"
# Expected response in json
# {"id":"bd7d03ef-7bc9-460a-bc25-df290a061ba0","customer":"HnHei","input_amount":"4032.02","input_currency":"NGN","output_amount":"34.21","output_currency":"EUR","created_at":"2022-02-13T15:02:17.128Z","updated_at":"2022-02-13T15:02:17.128Z"}
```

## Running with the deployed version

### API deployed demo host url

- [API Host](https://aza-fx-transaction-api.herokuapp.com/)

#### Access the API using the following curl command (or an API platform of your choice)

```bash
# POST /transactions
curl -X POST https://aza-fx-transaction-api.herokuapp.com/transactions -d "{\"customer\":\"HnHei\",\"input_amount\":\"4032.02\",\"input_currency\":\"NGN\",\"output_amount\":\"34.21\",\"output_currency\":\"EUR\"}" -H "Content-Type: application/json"
# Expected response in json
# {"id":"081be9c9-5d01-445f-9c02-61869e103734","customer":"HnHei","input_amount":"4032.02","input_currency":"NGN","output_amount":"34.21","output_currency":"EUR","created_at":"2022-02-13T15:08:21.975Z","updated_at":"2022-02-13T15:08:21.975Z"}

```

## Model Validation

Only one model `Transaction` is used in this app to store the transactions.

### Architectural decision used

- It is assumed that a different service handles the `Customer` table and only the `customer_id` is required to store the transactions.

- Date of transaction is assumed to be the date the transaction, `created_at` is created to avoid extra attributes if not necessary.

#### Data scheme

The transaction model has eight (8) attributes (columns) with the following scheme:

1. `id` - `uuid` is used to generate the id, this has the disadvantage of not sorting the transaction table automatically so a default scope is used to sort the table using the `created_at` column.

2. `customer` represents the `customer_id` with validation to allow 3 to 5 alphanumeric characters. This was done with the assumption that customer_id is not numeric and easy to guess.

3. `input_amount` and `output_amount` are stored as `decimal`(`BigDecimal`) on the db, but they accept both strings of numbers and numbers. Validation checks if it's not more than 2 decimal places and the integers are not more than 8 digits. The `BigDecimal` is more accurate with arithmetic calculations hence the preference over other similar data types.

4. `input_currency` and `output_currency` are store as string, model validation accepts three (3) uppercase letters that represents the [iso 4217 country alpha code](https://en.wikipedia.org/wiki/ISO_4217) format.

5. `created_at` and `updated_at` are auto generated `datetime`

See more details in the table below:

| Name            | Type       |                                            Model Validation                                            | Example                                |
| --------------- | ---------- | :----------------------------------------------------------------------------------------------------: | -------------------------------------- |
| id              | uuid       |                                                   -                                                    | `2a1281fe-acbe-4379-91c9-2db93dceef27` |
| customer        | `string`   |                                       3-5 aplha numeric letters                                        | `"x3ELU"`                              |
| input_amount    | `decimal`  |          8 digits with 2 decimal places, accepts a string of digits and cast into BigDecimal           | `"4032.02"`                            |
| input_currency  | `string`   | 3 uppercase letters to represent [iso 4217 country alpha code](https://en.wikipedia.org/wiki/ISO_4217) | `"NGN"`                                |
| output_amount   | `decimal`  |                                        same with `input_amount`                                        | `"4032.02"`                            |
| output_currency | `string`   |                                       same with `input_currency`                                       | `"NGN"`                                |
| created_at      | `datetime` |                                                   -                                                    | `"2022-02-13 15:00:55 UTC"`            |
| updated_at      | `datetime` |                                                   -                                                    | `"2022-02-13 15:00:55 UTC"`            |

## API Documentation

The API documentation playground is hosted using swagger UI and can be accessed [here](https://aza-fx-transaction-api.herokuapp.com/api-docs)

The [swagger ui](https://aza-fx-transaction-api.herokuapp.com/api-docs) documents the parameter, request and response.

### Testing

Request test, unit test (for regex), routing test and model test is written with RSpec and rswag (for API documentation). The test has 100% coverage covering the model, controller, regex and route.

#### QA

To run the automated test, run

```
rspec --force-color --format documentation
```

To run Rubocop by itself, you may run the lint task:

```bash
rubocop
```

Or to automatically fix issues found (where possible):

```bash
rubocop -a
```

You can also check against Prettier:

```bash
npx prettier  --check "**/*.{html,md,json,yaml,yml}"
```

and to have it fix (to the best of its ability) any format issues, run:

```bash
npx prettier  --write "**/*.{html,md,json,yaml,yml}"
```

## 👤 Author

- Github: [@bolah2009](https://github.com/bolah2009)
- Twitter: [@bolah2009](https://twitter.com/bolah2009)
- Linkedin: [@bolah2009](https://www.linkedin.com/in/bolah2009/)

## 📝 License

[MIT licensed](./LICENSE).
