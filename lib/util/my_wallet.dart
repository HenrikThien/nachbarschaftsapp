import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';

class MyWallet {
  static final String _walletPassword =
      "testpassword"; // todo: dynamic password

  static final String TOKEN_ABI =
      '[{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"tokens","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"from","type":"address"},{"name":"to","type":"address"},{"name":"tokens","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"tokenOwner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"to","type":"address"},{"name":"tokens","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"tokenOwner","type":"address"},{"name":"spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"tokens","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"tokenOwner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"tokens","type":"uint256"}],"name":"Approval","type":"event"}]';

  static final String TOKEN_ADDR = "0xef1a3c4bda51142284e8dee4c6a463118a561696";

  static final _localPath =
      getApplicationDocumentsDirectory().then((p) => p.path);

  static Future<File> _localFile(String uuid) async {
    final path = await _localPath;
    return File('$path/mywallet_' + uuid + '.json');
  }

  static Future<File> writeJsonWallet(String jsonWallet, String uuid) async {
    final file = await _localFile(uuid);
    return file.writeAsString('$jsonWallet');
  }

  static Future<String> readJsonFile(String uuid) async {
    try {
      final file = await _localFile(uuid);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "{}";
    }
  }

  static Future<Wallet> readWallet(String uuid) async {
    try {
      String content = await readJsonFile(uuid);
      Wallet wallet = Wallet.fromJson(content, _walletPassword);
      return wallet;
    } catch (e) {
      return null;
    }
  }

  static Future<Wallet> importWallet(String privateKey, String uid) async {
    try {
      Credentials fromHex = Credentials.fromPrivateKeyHex(privateKey);
      var rng = new Random.secure();
      Wallet wallet = Wallet.createNew(fromHex, _walletPassword, rng);
      await writeJsonWallet(wallet.toJson(), uid);
      return wallet;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<Wallet> createNewWallet(String uid) async {
    var rng = new Random.secure();
    Credentials random = Credentials.createRandom(rng);

    Wallet wallet = Wallet.createNew(random, _walletPassword, rng);

    await writeJsonWallet(wallet.toJson(), uid);

    return wallet;
  }

  static Future<double> getBalance(Credentials credits) async {
    var apiUrl =
        "https://ropsten.infura.io/v3/8ef759c567484986811f2f01b7a71530";

    var httpClient = new Client();
    var ethClient = new Web3Client(apiUrl, httpClient);

    var credentials = credits;

    EtherAmount balance = await ethClient.getBalance(credentials.address);
    return balance.getValueInUnit(EtherUnit.ether);
  }

  /*
  Works with normal smart contract
  */
  static Future<int> getContractBalance(Credentials credentials) async {
    var balance = 0;

    try {
      var apiUrl =
          "https://ropsten.infura.io/v3/8ef759c567484986811f2f01b7a71530";

      var httpClient = new Client();
      var ethClient = new Web3Client(apiUrl, httpClient);

      var contractAbi = ContractABI.parseFromJSON(TOKEN_ABI, "Nachbarschaft");

      var contract = new DeployedContract(
          contractAbi, new EthereumAddress(TOKEN_ADDR), ethClient, credentials);

      var getBalanceFn = contract.findFunctionsByName("balanceOf").first;

      var response = await new Transaction(keys: credentials, maximumGas: 0)
          .prepareForCall(contract, getBalanceFn,
              [credentials.address.number]).call(ethClient);

      balance = int.parse(response[0].toString());
    } catch (e) {
      print("getContractBalance: " + e.toString());
    }

    return balance;
  }
}
