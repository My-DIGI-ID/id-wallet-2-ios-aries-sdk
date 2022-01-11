# Aries Apple SDK

This framework is a modern Swift implementation of the Aries protocols and definitions. It's purpose is to provide a universal library for building SSI applications on the Apple platform, especially for mobile devices.

The overall structure is service based and designed following the [.NET implementation](https://github.com/hyperledger/aries-framework-dotnet). Each service implements one specific part of the Aries protocol and is provided with a ready-to-use default implementation. Wallets, records and messages make up the foundation for all other functionalities. Since everything is build on abstractions, the library is very modular and can be used with custom implementations. 

## Features

#### Wallet

The ``WalletService`` defines operations for creating, connecting and deleting wallets. `DefaultWalletService` is based on the iOS Wrapper of the Hyperledger Indy wallet and uses a file based storing mechanism.

#### Records

The `RecordService` defines operations for adding, querying, updating and deleting records in wallets. This is defined apart from the `WalletService` to gain more separation of concerns. Nevertheless, their implementations need to be corresponding since we always reference the wallet, when working with records. Therefore, `DefaultRecordService` is meant to be used with `DefaultWalletService` and is also based on the Hyperledger Indy wallet.

#### Messages (in development)

The `MessageService` enables communication with other Aries agents, where `DefaultMessageService` works with HTTP.

## Restrictions

#### Hyperledger Indy

Although Indy is a mature solution, there are several reasons, why this needs a replacement:

- Indy is not under active development since some time. Last release: 1.16.0 in February 2021
- This framework aims to be a solution for all Apple platforms. Indy only supports iOS, but also no arm64 Simulators, so working on newer Macs does only work with Rosetta.
- The dependencies of Indy are outdated to say the least.
- Due to the fact that the Indy binary contains functionality for a lot different use cases, the size is actually unacceptable for mobile purposes considering that we only need the wallet.

The overall solutions is enough for a first version of this framework, but it needs a modern longterm approach. There are two ideas which would achieve this overall goal:

- A native framework written in Swift, primarily based on a local database. This can be plugged in this framework to provide an overall modern idiomatic implementation of the Hyperledger protocols for all Apple platforms.
- Kotlin Multiplatform as a broader solution for a modern implementation for all platforms. This could be plugged in and extended over the future to its own Aries implementation.

