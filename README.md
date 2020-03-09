## Setup
----
Clone source code from github.

    git clone git@github.com:conficker1805/assignment.git

** For developers: **

* Install ruby: `rvm install "ruby-2.7.0"`
* Run `bundle install`
* Run `rails s`
* Run unit tests: `rspec`

** For docker user: **

* Run `docker-compose build`
* Run `docker-compose run web rake db:create db:migrate db:seed` to create database & add seeds
* Run `docker-compose up`
* Run unit tests `docker-compose run web rspec`

## How to test
** Postman: **
From Postman app, click `Import` - `Import from a link` - Paste the url below for importing
[https://www.getpostman.com/collections/5da0435bc56af18ec831](https://www.getpostman.com/collections/5da0435bc56af18ec831)

** Curl: **

* Submit a set of responses
```
curl --location --request POST 'http://localhost:3000/v1/answers' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
  "respondentIdentifier": "00001",
  "responses": [
    {
      "questionId": 1,
      "body":       2
    },
    {
      "questionId": 2,
      "body":       "My answer 2"
    },
    {
      "questionId": 3,
      "body":       2
    },
    {
      "questionId": 4,
      "body":       2
    },
    {
      "questionId": 5,
      "body":       2
    },
    {
      "questionId": 6,
      "body":       "My answer 6"
    }
  ]
}
'
```

* Fetch list of responses
```
curl --location --request GET 'http://localhost:3000/v1/answers' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw ''
```

* Fetch averaged response scores
```
curl --location --request GET 'http://localhost:3000/v1/questions/scored' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw ''
```

* Fetch question distributions
```
curl --location --request GET 'http://localhost:3000/v1/questions/distributions' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw ''
```
* Fetch question average scores base on demographic
```
curl --location --request GET 'http://localhost:3000/v1/questions/demographic' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw ''
```
