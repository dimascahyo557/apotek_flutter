import 'package:flutter/material.dart';

class DetailObat extends StatefulWidget {
  const DetailObat({super.key});

  @override
  State<DetailObat> createState() => _DetailObatState();
}

class _DetailObatState extends State<DetailObat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Obat', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          Image.asset('assets/medicine.jpg'),
          SizedBox(height: 16),
          Text(
            'Medicine Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            'Stock: 50',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Price: \$5.99',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 16),
          Text('Stock Change History'),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Stock Changed ${index + 1} days ago', style: TextStyle(fontSize: 14)),
                  subtitle: Text('5 units added', style: TextStyle(fontSize: 12)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}