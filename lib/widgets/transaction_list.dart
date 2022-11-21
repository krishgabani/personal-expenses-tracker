import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final providerOfTransaction = Provider.of<Transactions>(context);
    final transactions=providerOfTransaction.userTransaction;
    
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text('No transactions added yet!'),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          }))
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction:transactions[index],
                deleteTx: providerOfTransaction.removeTx,
              );
            },
            itemCount: transactions.length,
          );
  }
}
