# Modular Monolith on Rails Engines

The vision is to provide a Rails app that offers much of the functionality most Apps will need rather sooner than later - and keep it so modular that it will be easy to understand the separate parts and how they play together. It should also be easy to just comment out or delete unneeded Engines and obvious how to add a new one.

Hosting only one application and maintaining every dependency (e.g. a Postgres database) only once, simplifies the life of developers and can make an operations team redundant.

At the same time you want to avoid an entangled monolith. You want to have a modularized code base in which multiple teams can easily work in parallel with clear cut responsibilities while keeping the barriers for new team members low

And you want to stay future proof. There might be valid reasons to extract parts of the monolith to their own services, to connect them to different services or to even rewrite them in a different language. Fear not, as the modules will provide those clear cut borders that will allow to treat parts of the whole differently without changing the whole.

## The enclosing App

Should only provide the glue between the separated engines and some common config, tools, libs and helpers.

## Admin Engine

Manages all Admin data and Admin Auth.

## User Engine

Manages all User data and User Auth

Auth is handled separately by Admin and User as the requirements usually differ. Having explicit separation and some duplication should also simplify the code.

## Notification Engine

To send emails, text messages or any other type of notification.

## Content Engine

To input, display and manage markdown content - and to recycle qanda.

## Queueing Engine

Only Engine that will have a dependency to a Queueing system.

Also the only place to schedule jobs.

## File and Image Upload Engine

Handles all file uploads and all image processing and serving options.

## 4-Eye Change Request Engine

Allows to make any data change indirect, being only executed after an approval by another User or Admin.

Test run for the Change Request Engine before abstracting it to a gem. Test how it works with two different Actor models.

## Social Engine

Manage connections (follows, likes, re-shares) between Users, Admins and Content.

Enable to send messages to other Users and Admins.

## Business Logic Engine

Empty Engine to enter your own business logic.

Do not add your business logic to the App, keep it modular!

## General vision

When the modularization is done properly, it should be simple to extract an Engine to a gem or a microservice.

### Development Dependencies

and setup should be mostly the same for the App and all Engines, e.g.:

* rake tasks 
* rspec
* rswag for request specs and to create OpenApi docs
* capybara (when complex UI is involved)
* factory-bot (how to share factories for integration tests?)
* rubocop (with one rubocop.yml stored in the App)
* bundler-audit
* strong_migrations

### Dependencies

* Postgres for App and all Engines
* Devise for User and Admin Engines
* Redis and Sidekiq for Background Jobs Engine
* S3 and MiniMagick(?)
* dry-schema for validations in all Engines
* AppSignal in App
* GitHub Action workflows in App
* Ruby 3.1 and Rails 7.0 for all
* ChimeraHttpClient for all external requests
* jsonapi-serializer to generate JSON:API responses
* Settings to read ENV on boot
* Engines should use the same dependencies to solve the same problems
* while gems are declared in the Engines' gemspec files, they need to be open for a range of versions, as they are ultimately all bundled by the App

### Modularization

* namespace everything, including database-tables (all Engines and the App use the same database)
* database migrations stay in engines
* business logic internal to an Engine will be defined there
* business logic touching multiple Engines will be define in the App
* each Engine has its own test-suite (usually with the dummy app overhead) which will be executed on GitHub CI
* the App will provide (namespeced) integration specs for the interaction of the Engines
* probably introduce Packwerk on the CI later

### Rails Models, Repo-pattern, CQRS, Services...?

* all ids are UUIDs
* all Enums are proper postgres-enums
* add strict database validations and defaults
* the model should be used as DB adapter (Repo pattern)
* business logic who can store or update what should be extracted to Services
* business logic who can access what should be extracted to Services

### Input and Error flow

* Controllers use dry-schema to strictly validate any input
* Controller use Service for any more complex business logic
* Most writes should be queued in a background job
* Engines implement their own Callback endpoints
* Engines throw (namespaced) errors
* App handles all Errors in a Middleware
* Logging goes to STDOUT
* Exceptions go to AppSignal
* Routes are namespaced

### Hosting

* heroku
  
### Documentation

* the App's docs explains CI, deployment, hosting and other general topics
* the App's docs explains the whole product
* the App's docs link to the docs of the Engines
* each Engine maintains their own docs
* the Engine's docs explain their business logic
* the Engine's docs explain how to set it up for development
* the Engine's docs explain how to integrate it in an App
* the Engine's docs explain how to remove it from the App
* for all external API endpoints interactive OpenAPI docs should be provided
* ideally the App aggregates all the individual OpenAPI docs into one document
