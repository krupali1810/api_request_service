# AI-Assisted Build -- Ruby on Rails Assignment

## 📌 Overview

This project implements a backend service using Ruby on Rails that
processes requests asynchronously while handling: - Idempotency -
Concurrency - Retries - Failures

------------------------------------------------------------------------

## 🏗️ Architecture

Client → API → DB (Request stored) → Background Job (Sidekiq) →
Processing → Update Status

------------------------------------------------------------------------

## ⚙️ Tech Stack

-   Ruby on Rails (API-only)
-   PostgreSQL
-   Sidekiq + Redis
-   RSpec

------------------------------------------------------------------------

## 🔐 Idempotency Strategy

-   Client sends `Idempotency-Key` in headers
-   Stored in DB with unique index
-   Duplicate requests return existing response
-   Prevents duplicate processing

------------------------------------------------------------------------

## 🔁 Retry Strategy

-   Background jobs use Sidekiq retries
-   Only retry for temporary failures
-   Retry count tracked in DB

------------------------------------------------------------------------

## 🧵 Concurrency Handling

-   Used `with_lock` for row-level locking
-   Ensures only one process updates a request at a time

------------------------------------------------------------------------

## 📊 Request Lifecycle

States: - pending - processing - completed - failed - cancelled

------------------------------------------------------------------------

## 📡 API Endpoints

### Create Request

POST /api/v1/requests

Headers: Idempotency-Key: unique_key

Response: 202 Accepted

------------------------------------------------------------------------

### Get Request Status

GET /api/v1/requests/:id

------------------------------------------------------------------------

### Cancel Request

PATCH /api/v1/requests/:id/cancel

------------------------------------------------------------------------

## ⚠️ Edge Cases Handled

-   Duplicate requests
-   Retry duplication
-   Concurrent processing
-   Downstream failure
-   Cancellation
-   Invalid input

------------------------------------------------------------------------

## 🧪 Testing

-   RSpec used
-   Covers:
    -   Model validations
    -   Idempotency
    -   Job processing
    -   API behavior

------------------------------------------------------------------------

## 🚀 Setup Instructions

``` bash
bundle install
rails db:create db:migrate
redis-server
bundle exec sidekiq
rails server
```

------------------------------------------------------------------------

## 💡 Key Highlights

-   Idempotent by design
-   Safe retry mechanism
-   Concurrency handled via DB locks
-   Production-ready structure