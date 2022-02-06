
// import "package:flutter_web3/ethereum.dart";
// import "package:flutter_web3/ethers.dart";
// import "package:flutter_web3/wallet_connect.dart";

// import "package:flutter_web3_provider/ethereum.dart";
// import "package:flutter_web3_provider/ethers.dart";
// import "package:flutter_web3_provider/flutter_web3_provider.dart";

// import "package:flutter_web3/flutter_web3.dart";
// import 'package:flutter/services.dart';
// import 'package:flutter_web3/ethers.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

// import 'package:flutter_web3/flutter_web3.dart';
// import 'package:web3/web3.dart';
const erc20Abi =[
{
"constant": true,
"inputs": [],
"name": "name",
"outputs": [
{
"name": "",
"type": "string"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "_spender",
"type": "address"
},
{
"name": "_value",
"type": "uint256"
}
],
"name": "approve",
"outputs": [
{
"name": "",
"type": "bool"
}
],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "totalSupply",
"outputs": [
{
"name": "",
"type": "uint256"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "_from",
"type": "address"
},
{
"name": "_to",
"type": "address"
},
{
"name": "_value",
"type": "uint256"
}
],
"name": "transferFrom",
"outputs": [
{
"name": "",
"type": "bool"
}
],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "decimals",
"outputs": [
{
"name": "",
"type": "uint8"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [
{
"name": "_owner",
"type": "address"
}
],
"name": "balanceOf",
"outputs": [
{
"name": "balance",
"type": "uint256"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "symbol",
"outputs": [
{
"name": "",
"type": "string"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "_to",
"type": "address"
},
{
"name": "_value",
"type": "uint256"
}
],
"name": "transfer",
"outputs": [
{
"name": "",
"type": "bool"
}
],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [
{
"name": "_owner",
"type": "address"
},
{
"name": "_spender",
"type": "address"
}
],
"name": "allowance",
"outputs": [
{
"name": "",
"type": "uint256"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"payable": true,
"stateMutability": "payable",
"type": "fallback"
},
{
"anonymous": false,
"inputs": [
{
"indexed": true,
"name": "owner",
"type": "address"
},
{
"indexed": true,
"name": "spender",
"type": "address"
},
{
"indexed": false,
"name": "value",
"type": "uint256"
}
],
"name": "Approval",
"type": "event"
},
{
"anonymous": false,
"inputs": [
{
"indexed": true,
"name": "from",
"type": "address"
},
{
"indexed": true,
"name": "to",
"type": "address"
},
{
"indexed": false,
"name": "value",
"type": "uint256"
}
],
"name": "Transfer",
"type": "event"
}
];

final abi = [
  // Some details about the token
  "function name() view returns (string)",
  "function symbol() view returns (string)",

  // Get the account balance
  "function balanceOf(address) view returns (uint)",

  // Send some of your tokens to someone else
  "function transfer(address to, uint amount)",

  // An event triggered whenever anyone transfers to someone else
  "event Transfer(address indexed from, address indexed to, uint amount)"
];

var config = {
  "tokenAddress": "0xB4196CBf04126B7D2bA01d4fbAc5465Db9d03dc3",
  "privateKey": "8a36699157ae35b48132b2bd474718ffb03bd613e674064c43831f21c139e120",
  "rpcUrl": "https://data-seed-prebsc-1-s1.binance.org:8545/"
};


String rpc = "https://data-seed-prebsc-1-s1.binance.org:8545/";
String walletFrom = "0x375790EefceaB2CcAF59d17778239FdC0f4AC05B";
String privateKey = "8a36699157ae35b48132b2bd474718ffb03bd613e674064c43831f21c139e120";
String contractAddress = "";
String mainWallet = "0x020996e7a4fC9afC8393cB81a56AAf9896b64EA3";
int chainId = 97;

class Web3Class{
  late Client httpClient;
  late Web3Client web3;
  late EthPrivateKey credentials;
  @override
  Web3Class() {
    print("xx");
    httpClient = Client();
    web3 = Web3Client(rpc, httpClient);
  }
  @override
  void importWallet() {  
    credentials = EthPrivateKey.fromHex(privateKey);
  }
  @override
  void sendTransaction(String toWallet) async{
    await web3.sendTransaction(
      credentials,
      Transaction(
        from: EthereumAddress.fromHex(walletFrom),
        to: EthereumAddress.fromHex(toWallet),
        gasPrice: EtherAmount.inWei(BigInt.parse("100000000000")),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue (EtherUnit.gwei, 1000000),
      ),
      fetchChainIdFromNetworkId: false,
      chainId: chainId
    ).then((value){
      if(value == false) print("Error on transaction!");
      print(value);
    });
  }
  @override
  void swapTokens() {
    DeployedContract contract = DeployedContract(ContractAbi.fromJson(abi.toString(), "name"), EthereumAddress.fromHex(contractAddress));
    web3.call(contract: contract, function: ContractFunction("Transfer", []), params: []);
  }
}


void main(){
  Web3Class web3class = new Web3Class();
  web3class.importWallet();
  web3class.sendTransaction(mainWallet);
  
}




// class _TbtWalletState {
//   late Client httpClient;
//   late Web3Client ethClient;
//   bool data = false;
//   final myAddress = "0x9f87004bbdac6da72782d60da68373cbb9d8ae4c";
//   BigInt myData = BigInt.from(5);

//   @override
//   void initState() {
//     httpClient = Client();
//     ethClient = Web3Client(
//         "HERE YOUR ENDPOINT", //todo: I GOT ON MORALIS.IO FOR FREE 
//         httpClient);
//     balanceOf(myAddress);
//   }

//   Future<DeployedContract> loadContract() async {
//     String abi = await rootBundle.loadString("assets/abi.json");
//     //final List<dynamic> abiJson = jsonDecode(abi) as List<dynamic>;

//     String contractAddress = "0x6975103dec4b39b856ef1a1038920bd890e69d30";

//     final contract = DeployedContract(ContractAbi.fromJson(abi, "Test Ammount"),
//         EthereumAddress.fromHex(contractAddress));

//     return contract;
//   }

//   Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
//     final contract = await loadContract();
//     final ethFunction = contract.function(functionName);
//     final result = await ethClient.call(
//         contract: contract, function: ethFunction, params: args);

//     return result;
//   }

//   Future<void> balanceOf(String targetAddress) async {
//     List<dynamic> result =
//         await query("balanceOf", [EthereumAddress.fromHex(targetAddress)]);

//     myData = result[0];
//     data = true;
//   }
// }
  




























































// Provider web3 = JsonRpcProvider("https://data-seed-prebsc-1-s1.binance.org:8545/");
// Wallet wallet = Wallet("8a36699157ae35b48132b2bd474718ffb03bd613e674064c43831f21c139e120");
// Wallet walletWithProvider = wallet.connect(web3);
// Contract contract  = Contract("0xB4196CBf04126B7D2bA01d4fbAc5465Db9d03dc3", abi, wallet);
// //final transaction = contract.call("Transfer", ["0x375790EefceaB2CcAF59d17778239FdC0f4AC05B", "0xdc4904b5f716Ff30d8495e35dC99c109bb5eCf81", 900]);
// var balance = walletWithProvider.getBalance();

// Future test() async{
//   // var web3 = JsonRpcProvider(config["rpcUrl"]!);
//   // var web3 = JsonRpcProvider("https://data-seed-prebsc-1-s1.binance.org:8545/");
//   print("testx");
//   try {
//     print(await balance.toString());

    
//     //WalletConnectProvider.fromRpc({97: "https://data-seed-prebsc-1-s1.binance.org:8545/"}, network: "https://data-seed-prebsc-1-s1.binance.org:8545/", chainId: 97);//network:"https://data-seed-prebsc-1-s1.binance.org:8545/", bridge: null, qrCode: false, chainId: 97, networkId: 97, mobileLinks: null);  
//   } catch (e) {
//     print(e);
//   }
//   // var wallet =await promiseToFuture(Wallet("8a36699157ae35b48132b2bd474718ffb03bd613e674064c43831f21c139e120", web3));
//   // print(wallet.getBalance());
//   // var contract = Contract(config["tokenAddress"]!, erc20Abi, web3);  



// }


// // Hey, I am new on Dart Language and I have a problem with it. I am trying to use the module "flutter_web3" and I get an error that says "TypeError: Cannot read properties of undefined (reading 'Wallet')" when I try to access to variable in a function.
// // Example: 
// // ```dart
// // var contract  = Contract("TOKEN_ADDRESS", abi, PROVIDER); // this works with no error
// //  
// // void aFunction(){
// //  var contract  = Contract("TOKEN_ADDRESS", abi, PROVIDER); // this throws the error that I mentioned 
// // }
// // ```
// void main() {
//   test();
//   runApp(MaterialApp(home: Text("w")));
// }








































// //import 'package:flutter_web3_provider/ethers.dart';
// //import 'package:flutter_web3_provider/ethers.dart';
// //import 'package:flutter_web3_provider/ethers.dart';
// /*import 'package:flutter_web3_provider/ethereum.dart';
// import 'package:flutter_web3_provider/ethers.dart';*/
// import 'package:http/http.dart';
// import 'package:web3/web3.dart';
// import 'package:web3/src/chain/binance/bsc.dart';
// /*
// import "package:flutter_web3_provider/ethereum.dart";
// import "package:flutter_web3_provider/ethers.dart";
// import "package:flutter_web3/ethereum.dart";
// import "package:flutter_web3/ethers.dart";
// import "package:flutter_web3/flutter_web3.dart";
// import "package:flutter_web3/wallet_connect.dart";*/
// import "package:web3dart/web3dart.dart";
// import "package:web3dart/contracts.dart";
// import "package:web3dart/crypto.dart";
// import "package:web3dart/browser.dart";
// import "package:web3dart/credentials.dart";
// import "package:web3dart/json_rpc.dart";
// import "package:web3dart/contracts/erc20.dart";
// const String privateKey =
//     '8a36699157ae35b48132b2bd474718ffb03bd613e674064c43831f21c139e120';
// const String rpcUrl = 'https://data-seed-prebsc-1-s1.binance.org:8545/';

// Future<void> x2() async {
//   /*while (true) {
//     print("xx");
//     await Future.delayed(Duration.zero);
//   };*/
// }
// Future<void> x() async {
//   // start a client we can use to send transactions
//   final client = Web3Client(rpcUrl, Client());
//   final abi = [
//   // Some details about the token
//   "function name() view returns (string)",
//   "function symbol() view returns (string)",

//   // Get the account balance
//   "function balanceOf(address) view returns (uint)",

//   // Send some of your tokens to someone else
//   "function transfer(address to, uint amount)",

//   // An event triggered whenever anyone transfers to someone else
//   "event Transfer(address indexed from, address indexed to, uint amount)"
// ];
//   final credentials = EthPrivateKey.fromHex(privateKey);
//   final address = credentials.address;
// //  final tokenAddress = "0x917c7e541A170CB5d7D71CCf08F9c3156C163E21";
//   final tokenAddress = EthereumAddress.fromHex("0xB4196CBf04126B7D2bA01d4fbAc5465Db9d03dc3");
//   print(address.hexEip55);
//   while (true) {
//     //print(await client.getBalance(address));
//     try {
//       // credentials.sign()
//       print(2);
//       var deployed = DeployedContract(ContractAbi("name", abi, events), address);
//       // var contract =new Transaction.callContract(DeployedContract(abi, tokenAddress), ContractFunction());
      

//       // var contract = await Contract(tokenAddress, abi, credentials);
//     } catch (e) {
//       print(e);
//     }
//     print("object");
//     //await contract.transfer(tokenAddress, "1000");
//     //print("success");


//     // await contract.transfer(to, amount);
//     break;
//     await Future.delayed(Duration.zero);
//   }
//   print("exit async func Future<void> x()");
//   return;
//   var signed = await client.signTransaction(credentials, Transaction(
//       to: EthereumAddress.fromHex('0x020996e7a4fC9afC8393cB81a56AAf9896b64EA3'),
//       from: EthereumAddress.fromHex('0x375790EefceaB2CcAF59d17778239FdC0f4AC05B'),

//       gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
//       maxGas: 177302,
//       value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 1000000000000000000),
//     ),
//     chainId: 97);
//     await client.sendRawTransaction(signed);
//     print("success");
//   /*await client.sendTransaction(
//     credentials,
//     Transaction(
//       to: EthereumAddress.fromHex('0x020996e7a4fC9afC8393cB81a56AAf9896b64EA3'),
//       gasPrice: EtherAmount.inWei(BigInt.one),
//       maxGas: 100000,
//       value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
//     ),*/

//   await client.dispose();
// }
// void main(){
//   x2();
//   x();
//   runApp(MaterialApp(home: Text("w")));
// }
// // var hex = {
// //   'to': '0x020996e7a4fC9afC8393cB81a56AAf9896b64EA3',
// //   'private': '8a36699157ae35b48132b2bd474718ffb03bd613e674064c43831f21c139e120'
// // };

// // var eth = new Web3Client("https://data-seed-prebsc-1-s1.binance.org:8545/", Client());
// // //var eth = new Web3Client("http://localhost:8545/", new Client());
// // Future<void> x() async{
// //   var credentials = EthPrivateKey.fromHex("8a36699157ae35b48132b2bd474718ffb03bd613e674064c43831f21c139e120");
// //   await eth.sendTransaction(credentials, Transaction(
// //     to: EthereumAddress.fromHex(hex["to"]!),
// //     gasPrice: EtherAmount.inWei(BigInt.one),
// //     maxGas: 100000,
// //     value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1)
// //     ));
// // }
// // Web3Client()
// /*String test(){
//   var provider = Web3Provider(ethereum!);
//   return provider!.getBalance("0x020996e7a4fC9afC8393cB81a56AAf9896b64EA3").toString();
//   return "";
// }*/
//   //x.getSigner().sendTransaction(TxParams())

// /*
// class MyApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// */
// /*class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //return null;
//   }
// }*/
