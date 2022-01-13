# Aries Apple SDK

This framework is a modern Swift implementation of the Aries protocols and definitions. It's purpose is to provide a universal library for building SSI applications on the Apple platform, especially for mobile devices.

The overall structure is service based and designed following the [.NET implementation](https://github.com/hyperledger/aries-framework-dotnet). Each service implements one specific part of the Aries protocol and is provided with a ready-to-use default implementation. Wallets, records and messages make up the foundation for all other functionalities.

## Features

#### Wallet

The ``WalletService`` defines operations for creating, connecting and deleting wallets. `DefaultWalletService` is based on the iOS Wrapper of the Hyperledger Indy wallet and uses a file based storing mechanism.

#### Records

The `RecordService` defines operations for adding, querying, updating and deleting records in wallets. This is defined apart from the `WalletService` to gain more separation of concerns.

#### Messages

The `MessageService` enables communication with other Aries agents, where `DefaultMessageService` works with HTTP.

## Custom Implementations

Since everything is build on abstractions, the library is very modular, extensible and can be used with custom implementations. However, a lot of services depend on the functionalities in the Indy SDK, which makes them implicitly coupled. So if want to implement `WalletService`, `RecordService`, `CryptoService` or `ConnectionService`, it is very likely that you need to replace the others, too.

#### Reusing Tests

All tests for the services are defined against the protocols and therefore implementation agnostic. This enables reuse of the tests for custom implementations. In ordner to reuse an existing test for your implementation, you need to inherit from it and override the `service` property:

```swift
class CustomMyServiceTests: MyServiceTests {
    init() {
  			super.init()
      	service = CustomMyService()
    }
}
```

## Restrictions

#### Hyperledger Indy

Although Indy is a mature solution, there are several reasons, why this needs a replacement:

- Indy is not under active development since some time. Last release: 1.16.0 in February 2021
- This framework aims to be a solution for all Apple platforms. Indy only supports iOS, but also no arm64 Simulators, so working on newer Macs does only work with Rosetta.
- The dependencies of Indy are outdated to say the least.
- Due to the fact that the Indy binary contains functionality for a lot different use cases, the size is actually unacceptable for mobile purposes considering that we only need the wallet.
- The community is already considering alternatives to wallets: [RFC-440](https://github.com/hyperledger/aries-rfcs/blob/main/concepts/0440-kms-architectures/README.md)

The overall solutions is enough for a first version of this framework, but it needs a modern longterm approach. There are two ideas which would achieve this overall goal:

- Use of a more general KMS solution. This matches more the vision of Aries. Currently, none are known.
- A native framework written in Swift, primarily based on a local database. This can be plugged in this framework to provide an overall modern idiomatic implementation of the Hyperledger protocols for all Apple platforms.
- Kotlin Multiplatform as a broader solution for a modern implementation for all platforms. This could be plugged in and extended over the future to its own Aries implementation.

