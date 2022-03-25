# Galesburg Eats

Galesburg Eats was started as a project during the early pandemic in an attempt to provide a local solution for ordering/picking up food from restaurants in Galesburg, IL. There were two objectives for the MVP: 1) Provide an easily-accessible/moderately customizeable menu page for restaurants (most restaurants in the area either have no web presence or rely on Facebook for this) and 2) Allow customers to "reserve" an order that the restaurant can then either accept/reject. The MVP was to include no payment processing in order to minimize the complexity of integrating the service; this would also help local restaurants keep 100% of the revenue.

The project was subsequently abandoned, but makes for a good sample application!

## Getting Started

### With Docker (Recommended)
First, follow [these instructions](https://docs.docker.com/get-docker/) to install Docker Desktop if don't have it installed.

If you're not doing any dev work on the frontend client, you can simply uncomment it in `docker-compose.yml` and it should start up in a docker container when you run the commands below. If you are planning to make changes to the frontend client, you'll want to keep that service commented out in `docker-compose.yml`, clone the [frontend client](https://github.com/heymitchfischer/galesburg-eats-client), and follow its initialization instructions as well.
```
docker-compose build
docker-compose run galesburg_eats_api rails db:setup
docker-compose up
```

To run tests (replace `run` with `exec` if you have the containers running already):
```
docker-compose run galesburg_eats_api rspec spec
```

To enter the rails console (replace `run` with `exec` if you have the containers running already):
```
docker-compose run galesburg_eats_api rails c
```

### Bare Metal
```
bundle install
rails db:setup
rails s
```

Make sure to clone the [frontend client](https://github.com/heymitchfischer/galesburg-eats-client) and follow its initialization instructions as well.
