# Aries Apple SDK

This framework is a modern Swift implementation of the Aries protocols and definitions. It's purpose is to provide a universal library for building SSI applications on the Apple platform, especially for mobile devices.

### Features
- Wallets (in development)
- Records (in development)


### Restrictions

##### Supported Platforms

In the current state of the project the only supported architecture is arm64. This is due to the OpenSSL dependency in the Indy SDK which was compiled against only this architecture. 

Therefore, you will only be able to run the tests or applications using this implementation on **real** iOS devices. This is a critical issue in regard of automating tests and deployments as this is performed on simulators which run a x86 architecture.

In order to resolve this issue, a few steps need to be made to produce a compatible artifact of the Indy SDK:

1. Compiling the OpenSSL library against the x86 architecture
2. Merging the two static archives into a fat one
3. Rebuilding the iOS Wrapper of the Indy SDK for arm64 and x86 with the newly generated archive 
4. Merging the two framework files into a XCFramwork.

Keep in mind that this process can introduce further problems on the way.
