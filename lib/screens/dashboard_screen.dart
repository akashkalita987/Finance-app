import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../screens/add_transaction_screen.dart';
import '../screens/history_screen.dart';
import '../screens/chart_screen.dart';
import '../services/storage_service.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await StorageService.loadTransactions();
    setState(() => _transactions = data);
  }

  Future<void> _addTransaction(Transaction tx) async {
    setState(() => _transactions.insert(0, tx));
    await StorageService.saveTransactions(_transactions);
  }

  Future<void> _deleteTransaction(String id) async {
    setState(() => _transactions.removeWhere((t) => t.id == id));
    await StorageService.saveTransactions(_transactions);
  }

  double get _totalIncome => _transactions
      .where((t) => !t.isExpense)
      .fold(0, (s, t) => s + t.amount);
  double get _totalExpense => _transactions
      .where((t) => t.isExpense)
      .fold(0, (s, t) => s + t.amount);
  double get _balance => _totalIncome - _totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ChartScreen(transactions: _transactions)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HistoryScreen(
                  transactions: _transactions,
                  onDelete: _deleteTransaction,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.indigo[600],
            child: Column(
              children: [
                const Text('Total Balance',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 14)),
                Text(
                  '₹${_balance.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryCard('Income', _totalIncome, Colors.greenAccent),
                    _summaryCard('Expenses', _totalExpense, Colors.redAccent),
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Transactions',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          Expanded(
            child: _transactions.isEmpty
                ? const Center(
                    child: Text('No transactions yet. Tap + to add one!'))
                : ListView.builder(
                    itemCount: _transactions.length > 10
                        ? 10
                        : _transactions.length,
                    itemBuilder: (_, i) => TransactionTile(
                      tx: _transactions[i],
                      onDelete: () =>
                          _deleteTransaction(_transactions[i].id),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AddTransactionScreen(onAdd: _addTransaction),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _summaryCard(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label,
            style:
                const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}