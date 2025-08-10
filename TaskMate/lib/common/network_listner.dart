import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkListener extends StatefulWidget {
  final Widget child;
  const NetworkListener({super.key, required this.child});

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  final Connectivity _connectivity = Connectivity();
  late final Stream<ConnectivityResult> _stream;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _stream = _connectivity.onConnectivityChanged;
    _stream.listen((result) {
      final isConnected = result != ConnectivityResult.none;
      if (!isConnected && !_isOffline) {
        _isOffline = true;
        _showNoConnectionSnackbar();
      } else if (isConnected && _isOffline) {
        _isOffline = false;
        _showConnectedSnackbar();
      }
    });
  }

  void _showNoConnectionSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("⚠ No Internet Connection"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showConnectedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Back Online"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
