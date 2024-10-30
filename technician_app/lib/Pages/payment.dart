import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF6E01CA), // Purple shade
      ),
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF243D66), // Dark blue shade for background
      appBar: AppBar(
        backgroundColor: Color(0xFF6E01CA), // Purple shade for app bar
        title: Text('Payment Amount', style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Payment Amount',
                fillColor: Color(0xFFEBECF1), // Light gray for text field background
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PaymentOptionButton(
                  label: 'Cash',
                  icon: Icons.attach_money,
                ),
                PaymentOptionButton(
                  label: 'QR Pay',
                  icon: Icons.qr_code,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC285FA), // Light purple for confirm button
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text('Confirm', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF6E01CA), // Purple for bottom navigation bar
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.add_box, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.download, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;

  PaymentOptionButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Color(0xFF4FB0C6), // Blue shade for option buttons
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
