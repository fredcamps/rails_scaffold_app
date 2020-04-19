# README
## This document cover this app installation.

* Ruby version: 2.5.7

* System dependencies:
Docker: 19.03
docker-compose: 1.25.5

* Configuration
Run this command bellow and wait for all services be loaded
```
docker-compose up
```
When all services loaded, send to backgroup or open another terminal window

* Database creation
Already created inside database container

* Database initialization
```
docker-compose run --rm app sh -c 'rails db:migrate && rails db:fixtures:load'
docker-compose run --rm app sh -c 'rails db:migrate RAILS_ENV=test'
```

* How to run the test suite
```
docker-compose run --rm app sh -c 'rails test'
```

* Services
postgres:12.2 as database
puma as app server

* Application usage example
Save new DNS record
```
curl -d '@payload.json' -H "Accept: application/json" -H "Content-Type: application/json" -X POST "http://localhost:3000/api/v1/dns_records"
``
Search for dns records
```
curl -H "Accept: application/json" -H "Content-Type: application/json" -X GET "http://localhost:3000/api/v1/dns_records/1?include=dolor.com,ipsum.com&exclude=sit.com""
```
