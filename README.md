# Aries SDK For Apple Platforms

This framework is a modern Swift implementation of the Aries protocols and definitions. It's purpose is to provide a universal library for building SSI applications on the Apple platform, especially for mobile devices.

The overall structure is service based and designed following the [.NET implementation](https://github.com/hyperledger/aries-framework-dotnet). Each service implements one specific part of the Aries protocol and is provided with a ready-to-use default implementation. Wallets, records and messages make up the foundation for all other functionalities.

## Features

At this point, the implementation is incomplete in terms of the "full cycle". This means you can fulfill a DID exchange / establish a connection and issue credentials but don't proof them. Anyway, the following features are supported:

- Managing wallets and records.
- Sending and receiving messages over HTTP including (un-)packing.
- Negotiating and receiving credentials.
- Connecting to a pool and reading data from a ledger.
- Different kinds of message decorators.

## Restrictions

#### Hyperledger Indy

Unfortunately, Indy imposes a lot of restrictions and disadvantages:

- Currently, the underlying Indy binary in the Swift-Wrapper is only built for iOS (arm64-device and x86_64-simulator)
  - It forces developers who use Macs operating the new M-Processors to run XCode with Rosetta, which has implications in itself.
  - It basically denies to multiplatform character of this package.
  - Building Indy for all platforms on your own and merging them into a XCFramework is a real torture. We have paused this approach for now, as too much time is needed to overcome all challenges.
- Indy is not under active development and also its dependencies are stale.
- Indy contains a lot of functionality which is not needed for the mobile use case which bloats up the binary significantly.
- This framework should be agnostic to the underlying ledger which means a lot more work has to be done to replace the needed functionality.

#### Mediation

Since the main purpose of this framework is to provide agent functionality to mobile apps, you are basically forced to also use the mediator package, because there is no other way to receive messages without any effort of the receiver. This means you also need access to a mediator agent. You can host one on your own with the other Aries implementations like the .NET or Python.
