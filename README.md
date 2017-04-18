# Leviathan
Leviathan is a iOS and macOS client application for the Mastodon social network.

To compile the app, you need to install the following tools:
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)
- [Carthage](https://github.com/Carthage/Carthage)

Before you compiling the app, you need to get and compile the dependencies issueing the following command in the project directory:

```sh
carthage bootstrap --platform iOS,macOS --no-use-binaries
```
