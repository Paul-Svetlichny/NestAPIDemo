# Nest API Demo

Sample iOS app demonstrating Nest Developer Authentication, API requests to read and write data from remote, simple thermostat controls and showing structure details.

## Basic functionality

The app provides the following functionality:
- Authentication
- Display Structure name and basic details: how many devices are connected, status of smoke-CO alarms
- Display thermostat name
- Display current temperature in °F and °C
- Display target temperature in °F and °C
- Change target temperature in °F and °C
- Switching between temperature scales
- Display humidity
- Display HVAC state
- Display availability of: fan, heather, cooler, fan timer

The current interface shows the availability of smoke-CO alarms, but this was not yet implemented and will be available in next app version.

### Prerequisites

No additional prerequisites are required. The project is built with all native frameworks without Cocoapods dependencies.

## Running the tests

The project is partially covered with unit tests. Due to limited time there are no integration and UI tests.

## ToDos

The project requires the following to be improved:

Features

- Add support for Smoke-CO alarms
- Add camera support
- Add syncing mechanism to sync system state in realtime

Tests

- Better test coverage
- Add UI tests
- Add integration tests

## Versioning

Current version is 0.0.1. There were no version changes during the development. Versioning will be applied on the later stages. This documentation will also reflect version changes.

## Authors

* **Paul Svetlichny** - *Initial work* - (https://github.com/Paul-Svetlichny)


