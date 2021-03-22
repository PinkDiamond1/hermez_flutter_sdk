import 'api.dart' as coordinatorApi;
import 'constants.dart' as constants;

EnvParams params = Env().params['local'];

class Env {
  Env() {
    params['local'] = EnvParams(
        1337,
        {
          "0x10465b16615ae36F350268eb951d7B0187141D3B", // Hermez
          "0x8EEaea23686c319133a7cC110b840d1591d9AeE0" // WithdrawalDelayer
        },
        //"192.168.1.134:8086",
        //'192.168.1.134:8545',
        //"192.168.1.134:8080",
        "192.168.250.101:8086",
        'http://192.168.250.101:8545',
        'wss://192.168.250.101:8545',
        "192.168.250.101:8080",
        "https://etherscan.io",
        "http://api.etherscan.io/api",
        "B697CBT5AUE1PUSUGFXZUIFVBFG8G7889D");

    params['rinkeby'] = EnvParams(
        4,
        {
          "0x679b11E0229959C1D3D27C9d20529E4C5DF7997c", // Hermez
          "0xeFD96CFBaF1B0Dd24d3882B0D6b8D95F85634724", // WithdrawalDelayer
        },
        "api.testnet.hermez.io",
        "https://rinkeby.infura.io/v3/80596e41f0a148ccbc9a856abd054696",
        "wss://rinkeby.infura.io/v3/80596e41f0a148ccbc9a856abd054696",
        "https://explorer.testnet.hermez.io",
        "https://rinkeby.etherscan.io",
        "http://api-rinkeby.etherscan.io/api",
        "B697CBT5AUE1PUSUGFXZUIFVBFG8G7889D");
  }

  Map<String, EnvParams> params = Map<String, EnvParams>();

  static final Set<String> supportedEnvironments = {
    "local",
    "rinkeby",
  };
}

class EnvParams {
  EnvParams(
      this.chainId,
      this.contracts,
      this.baseApiUrl,
      this.baseWeb3Url,
      this.baseWeb3RdpUrl,
      this.batchExplorerUrl,
      this.etherscanUrl,
      this.etherscanApiUrl,
      this.etherscanApiKey);
  final int chainId;
  final Set<String> contracts;
  final String baseApiUrl;
  final String baseWeb3Url;
  final String baseWeb3RdpUrl;
  final String batchExplorerUrl;
  final String etherscanUrl;
  final String etherscanApiUrl;
  final String etherscanApiKey;
}

/// Gets the current supported environments
/// @returns {Object[]} Supported environments
Set<String> getSupportedEnvironments() {
  return Env.supportedEnvironments;
}

/// Sets an environment from a chain id or from a custom environment object
/// @param {Object|Number} env - Chain id or a custom environment object
void setEnvironment(String env) {
  if (env == null) {
    throw new ArgumentError('A environment is required');
  }

  if (!getSupportedEnvironments().contains(env)) {
    throw new ArgumentError('Environment not supported');
  }

  params = Env().params[env];
  constants.contractAddresses['Hermez'] = params.contracts.first;
  constants.contractAddresses['WithdrawalDelayer'] = params.contracts.last;
  coordinatorApi.setBaseApiUrl(params.baseApiUrl);
}

/// Returns the current environment
/// @returns {Object} Contains contract addresses, Hermez API and Batch Explorer urls
/// and the Etherscan URL por the provider
EnvParams getCurrentEnvironment() {
  return params;
}
