import 'package:hermez_plugin/http.dart' show extractJSON, get, post;

import 'addresses.dart' show isHermezEthereumAddress, isHermezBjjAddress;
import 'constants.dart' show DEFAULT_PAGE_SIZE;

const baseApiUrl = 'http://167.71.59.190:4010';

const REGISTER_AUTH_URL = "/account-creation-authorization";
const ACCOUNTS_URL = "/accounts";
const EXITS_URL = "/exits";
const STATE_URL = "/state";

const TRANSACTIONS_POOL_URL = "/transactions-pool";
const TRANSACTIONS_HISTORY_URL = "/transactions-history";

const TOKENS_URL = "/tokens";
const RECOMMENDED_FEES_URL = "/recommendedFee";
const COORDINATORS_URL = "/coordinators";

/// Sets the query parameters related to pagination
/// @param {int} fromItem - Item from where to start the request
/// @returns {object} Includes the values `fromItem` and `limit`
/// @private
Map<String, dynamic> getPageData(int fromItem) {
  return {
    "fromItem": !fromItem.isNaN ? fromItem : {},
    "limit": DEFAULT_PAGE_SIZE
  };
}

/// GET request to the /accounts endpoint. Returns a list of token accounts associated to a Hermez address
/// @param {string} address - The account's address. It can be a Hermez Ethereum address or a Hermez BabyJubJub address
/// @param {int[]} tokenIds - Array of token IDs as registered in the network
/// @param {int} fromItem - Item from where to start the request
/// @returns {object} Response data with filtered token accounts and pagination data
Future<String> getAccounts(String address, List<int> tokenIds,
    {int fromItem = 0}) async {
  Map<String, String> params = {};
  if (isHermezEthereumAddress(address) && address.isNotEmpty)
    params.putIfAbsent('hezEthereumAddress', () => address);
  if (isHermezBjjAddress(address) && address.isNotEmpty)
    params.putIfAbsent('BJJ', () => address);
  if (tokenIds.isNotEmpty)
    params.putIfAbsent('tokenIds', () => tokenIds.join(','));
  params.addAll(getPageData(fromItem));
  return extractJSON(
      await get(baseApiUrl, ACCOUNTS_URL, queryParameters: params));
}

/// GET request to the /accounts/:accountIndex endpoint. Returns a specific token account for an accountIndex
/// @param {string} accountIndex - Account index in the format hez:DAI:4444
/// @returns {object} Response data with the token account
Future<String> getAccount(String accountIndex) async {
  return extractJSON(await get(baseApiUrl, ACCOUNTS_URL + '/' + accountIndex));
}

/// GET request to the /transactions-histroy endpoint. Returns a list of forged transaction based on certain filters
/// @param {string} address - Filter by the address that sent or received the transactions. It can be a Hermez Ethereum address or a Hermez BabyJubJub address
/// @param {int[]} tokenIds - Array of token IDs as registered in the network
/// @param {int} batchNum - Filter by batch number
/// @param {String} accountIndex - Filter by an account index that sent or received the transactions
/// @param {int} fromItem - Item from where to start the request
/// @returns {object} Response data with filtered transactions and pagination data
Future<String> getTransactions(String address, List<int> tokenIds, int batchNum,
    String accountIndex, int fromItem) async {
  Map<String, String> params = {};
  if (isHermezEthereumAddress(address) && address.isNotEmpty)
    params.putIfAbsent('hezEthereumAddress', () => address);
  if (isHermezBjjAddress(address) && address.isNotEmpty)
    params.putIfAbsent('BJJ', () => address);
  if (tokenIds.isNotEmpty)
    params.putIfAbsent('tokenIds', () => tokenIds.join(','));
  params.putIfAbsent('batchNum', () => batchNum > 0 ? batchNum.toString() : '');
  params.putIfAbsent('accountIndex', () => accountIndex);
  params.addAll(getPageData(fromItem));
  return extractJSON(
      await get(baseApiUrl, TRANSACTIONS_HISTORY_URL, queryParameters: params));
}

/// GET request to the /transactions-history/:transactionId endpoint. Returns a specific forged transaction
/// @param {string} transactionId - The ID for the specific transaction
/// @returns {object} Response data with the transaction
Future<String> getHistoryTransaction(String transactionId) async {
  return extractJSON(
      await get(baseApiUrl, TRANSACTIONS_HISTORY_URL + '/' + transactionId));
}

/// GET request to the /transactions-pool/:transactionId endpoint. Returns a specific unforged transaction
/// @param {string} transactionId - The ID for the specific transaction
/// @returns {object} Response data with the transaction
Future<String> getPoolTransaction(String transactionId) async {
  return extractJSON(
      await get(baseApiUrl, TRANSACTIONS_POOL_URL + '/' + transactionId));
}

/// POST request to the /transaction-pool endpoint. Sends an L2 transaction to the network
/// @param {object} transaction - Transaction data returned by TxUtils.generateL2Transaction
/// @returns {string} Transaction id
Future<String> postPoolTransaction(dynamic transaction) async {
  return extractJSON(
      await post(baseApiUrl, TRANSACTIONS_POOL_URL, body: transaction));
}

/// GET request to the /exits endpoint. Returns a list of exits based on certain filters
/// @param {string} address - Filter by the address associated to the exits. It can be a Hermez Ethereum address or a Hermez BabyJubJub address
/// @param {boolean} onlyPendingWithdraws - Filter by exits that still haven't been withdrawn
/// @returns {object} Response data with the list of exits
Future<String> getExits(String address, bool onlyPendingWithdraws) async {
  Map<String, String> params = {};
  if (isHermezEthereumAddress(address) && address.isNotEmpty)
    params.putIfAbsent('hezEthereumAddress', () => address);
  if (isHermezBjjAddress(address) && address.isNotEmpty)
    params.putIfAbsent('BJJ', () => address);
  params.putIfAbsent(
      'onlyPendingWithdraws', () => onlyPendingWithdraws.toString());
  return extractJSON(await get(baseApiUrl, EXITS_URL, queryParameters: params));
}

/// GET request to the /exits/:batchNum/:accountIndex endpoint. Returns a specific exit
/// @param {int} batchNum - Filter by an exit in a specific batch number
/// @param {string} accountIndex - Filter by an exit associated to an account index
/// @returns {object} Response data with the specific exit
Future<String> getExit(int batchNum, String accountIndex) async {
  return extractJSON(await get(
      baseApiUrl, EXITS_URL + '/' + batchNum.toString() + '/' + accountIndex));
}

/// GET request to the /tokens endpoint. Returns a list of token data
/// @param {int[]} tokenIds - An array of token IDs
/// @returns {object} Response data with the list of tokens
Future<String> getTokens(List<int> tokenIds) async {
  Map<String, String> params = {
    "tokenIds": tokenIds.isNotEmpty ? tokenIds.join(',') : ''
  };

  return extractJSON(
      await get(baseApiUrl, TOKENS_URL, queryParameters: params));
}

/// GET request to the /tokens/:tokenId endpoint. Returns a specific token
/// @param {int} tokenId - A token ID
/// @returns {object} Response data with a specific token
Future<String> getToken(int tokenId) async {
  return extractJSON(
      await get(baseApiUrl, TOKENS_URL + '/' + tokenId.toString()));
}

/// GET request to the /state endpoint.
/// @returns {object} Response data with the current state of the coordinator
Future<String> getState() async {
  final state = extractJSON(await get(baseApiUrl, STATE_URL));
  // Remove once hermez-node is ready
  // state.withdrawalDelayer.emergencyMode = true
  // state.withdrawalDelayer.withdrawalDelay = 60
  // state.rollup.buckets[0].withdrawals = 0
  return state;
}
