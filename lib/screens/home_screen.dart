import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../models/transaction.dart';
import '../widgets/chart.dart';
import '../widgets/transaction_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  List<Widget> _buildPortraitContent(AppBar appBar, BuildContext context) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(),
      ),
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(),
      )
    ];
  }

  List<Widget> _buildLandscapeContent(AppBar appBar, BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch(
              //Switch.adaptive
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(),
            )
          : Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: TransactionList(),
            ),
    ];
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Transactions>(context).fetchAndSet();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool _showChart = false;
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(fontFamily: 'Quicksand'),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Provider.of<Transactions>(context, listen: false)
              .addNewTransition(context),
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('If you want to Logout,hit YES.'),
                actions: [
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('YES'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                  ),
                ],
              ),
            );
            // Navigator.of(context).pushReplacementNamed('/');
            // Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isLandscape) ..._buildLandscapeContent(appBar, context),
                  if (!isLandscape) ..._buildPortraitContent(appBar, context),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Provider.of<Transactions>(context, listen: false)
            .addNewTransition(context),
      ),
    );
  }
}
