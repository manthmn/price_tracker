import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const PriceTracker(),
    );
  }
}

class PriceTracker extends StatefulWidget {
  const PriceTracker({Key? key}) : super(key: key);

  @override
  State<PriceTracker> createState() => _PriceTrackerState();
}

class _PriceTrackerState extends State<PriceTracker> {
  String price = "0";
  late IOWebSocketChannel channel;
  String errorMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() {
    setState(() {
      isLoading = true;
    });

    try {
      channel = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws/btcusdt@trade');
      channel.stream.listen((message) {
        try {
          Map getData = jsonDecode(message);
          setState(() {
            price = getData['p'].toString();
            errorMessage = '';
            isLoading = false;
          });
        } catch (e) {
          setState(() {
            errorMessage = 'Error parsing data';
            isLoading = false;
          });
        }
      }, onError: (error) {
        setState(() {
          errorMessage = 'Connection error: $error';
          isLoading = false;
        });
      }, onDone: () {
        setState(() {
          errorMessage = 'Connection closed';
          isLoading = false;
        });
      });

    } catch (e) {
      setState(() {
        errorMessage = 'Error connecting to WebSocket: $e';
        isLoading = false;
      });
    }
  }

  void retryConnection() {
    setState(() {
      errorMessage = '';
      price = '0';
    });
    connectToWebSocket();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'Price Tracker',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                ' (Bitcoin)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading
          ? const CircularProgressIndicator(color: Colors.deepPurple)
          : TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.all(16)),
              onPressed: errorMessage.isNotEmpty ? retryConnection : null,
              child: Text(
                errorMessage.isNotEmpty ? 'Retry' : '\$ ${double.parse(price).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
              ),
            ),
      ),
    );
  }
}
