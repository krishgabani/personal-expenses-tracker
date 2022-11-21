import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/new_transaction.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    required this.amount,
    required this.date,
    required this.id,
    required this.title,
  });
}

class Transactions with ChangeNotifier {

  List<Transaction> _userTransaction = [];
  final String authToken;
  final String userId;
  Transactions(this.authToken, this.userId, this._userTransaction);


  List<Transaction> get userTransaction {
    return _userTransaction;
  }

  List<Transaction> get recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  Future<void> fetchAndSet() async {
    final url = Uri.parse(
        'https://personalexpenses-c78a7-default-rtdb.firebaseio.com/transactions/$userId.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      if (fetchedData == null) {
        return;
      }
      print('userId');
      print(userId);
      print('response.body');
      print(response.body);
      final List<Transaction> loadedTx = [];
      fetchedData.forEach((txId, txData) {
        loadedTx.add(
          Transaction(
            amount: txData['amount'],
            date: DateTime.parse(txData['date']),
            id: txId,
            title: txData['title'],
          ),
        );
      });
      _userTransaction=loadedTx;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addNewTx(
      String txTitle, double txAmount, DateTime chosenDate) async {
    final url = Uri.parse(
        'https://personalexpenses-c78a7-default-rtdb.firebaseio.com/transactions/$userId.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': txTitle,
          'amount': txAmount,
          'date': chosenDate.toIso8601String(),
          // 'creatorId': userId,
        }),
      );
      final newTx = Transaction(
        id: json.decode(response.body)['name'],
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
      );

      _userTransaction.add(newTx);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeTx(String id) async {
    final url = Uri.parse(
        'https://personalexpenses-c78a7-default-rtdb.firebaseio.com/transactions/$userId/$id.json?auth=$authToken');
    final response = await http.delete(url);

    _userTransaction.removeWhere((tx) {
      return tx.id == id;
    });
    notifyListeners();
  }

  void addNewTransition(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction();
      },
    );
    notifyListeners();
  }
}
