# hermez_sdk

## Description

This is a flutter Plugin for Hermez Mobile SDK (https://hermez.io). This plugin provides a cross-platform tool (iOS, Android) to communicate with the Hermez API and network.

## Installation

To use this plugin, add `hermez_sdk` as a [dependency](https://flutter.io/using-packages/) in your `pubspec.yaml` file like this

```yaml
dependencies:
  hermez_sdk: ^x.y.z
```
This will get you the latest version.

If you want to test a specific branch of the repository, pull `hermez_sdk` like this

```yaml
dependencies:
  hermez_sdk:
      git:
        url: ssh://git@github.com/hermeznetwork/hermez-mobile-library.git
        ref: branchPathName
```

## Setup

NOTE: In order to interact with Hermez, you will need to supply your own Ethereum node. You can check these links to help you set up a node (https://blog.infura.io/getting-started-with-infura-28e41844cc89, https://blog.infura.io/getting-started-with-infuras-ethereum-api).

## Usage

To start using this package first import it in your Dart file.

```dart
import 'package:hermez_sdk/hermez_sdk.dart';
```

### Initialization

To initialize the Hermez SDK you can call the init method with one of the supported environments as a parameter, or setup all the different parameters passing the environment 'custom'.

```dart
HermezSDK.init(
  'rinkeby',
   web3ApiKey: EXAMPLES_WEB3_API_KEY
);
```

or 

```dart
HermezSDK.init(
  'custom',
  envParams: EnvParams(
      EXAMPLES_WEB3_CHAIN_ID,
      {
        ContractName.hermez: EXAMPLES_HERMEZ_ROLLUP_ADDRESS, // Hermez
        ContractName.withdrawalDelayer:
            EXAMPLES_HERMEZ_WDELAYER_ADDRESS, // WithdrawalDelayer
      },
      EXAMPLES_HERMEZ_API_URL,
      EXAMPLES_HERMEZ_EXPLORER_URL,
      EXAMPLES_WEB3_URL + EXAMPLES_WEB3_API_KEY,
      EXAMPLES_WEB3_RDP_URL + EXAMPLES_WEB3_API_KEY),
);
```

### Supported Tokens

Before being able to operate on the Hermez Network, we must ensure that the token we want to operate with is listed. For that we make a call to the Hermez Coordinator API that will list all available tokens. All tokens in Hermez Network must be ERC20.

We can see there are 2 tokens registered. ETH will always be configured at index 0. The second token is HEZ. For the rest of the examples we will work with ETH. In the future, more tokens will be included in Hermez.

```dart
import 'package:hermez_sdk/api.dart' as coordinatorApi;

...

Future<TokensResponse> getHermezSupportedTokens() async {
  TokensResponse tokensResponse = await coordinatorApi.getTokens();
  return tokensResponse;
}
```

```json
{
  "tokens": [
    {
      "itemId": 1,
      "id": 0,
      "ethereumBlockNum": 0,
      "ethereumAddress": "0x0000000000000000000000000000000000000000",
      "name": "Ether",
      "symbol": "ETH",
      "decimals": 18,
      "USD": 1787,
      "fiatUpdate": "2021-02-28T18:55:17.372008Z"
    },
    {
      "itemId": 2,
      "id": 1,
      "ethereumBlockNum": 8153596,
      "ethereumAddress": "0x2521bc90b4f5fb9a8d61278197e5ff5cdbc4fbf2",
      "name": "Hermez Network Token",
      "symbol": "HEZ",
      "decimals": 18,
      "USD": 5.365,
      "fiatUpdate": "2021-02-28T18:55:17.386805Z"
    }
  ],
  "pendingItems": 0
}
```

### Create Wallet

### Move tokens from Ethereum to Hermez Network

### Token Balance

### Move tokens from Hermez to Ethereum Network

#### Exit

#### Withdraw

#### Force Exit

### Transfers

### Transaction Status

### Create Account Authorization


