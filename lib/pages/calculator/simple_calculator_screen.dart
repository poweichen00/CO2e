import 'package:c_o2e/flutter_flow/flutter_flow_theme.dart';
import 'package:c_o2e/flutter_flow/nav/nav.dart';
import 'package:c_o2e/index.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../flutter_flow/calendar.dart';

class SimpleCalculatorScreen extends StatefulWidget {
  const SimpleCalculatorScreen({super.key});

  @override
  _SimpleCalculatorScreenState createState() => _SimpleCalculatorScreenState();
}

class _SimpleCalculatorScreenState extends State<SimpleCalculatorScreen> {
  final Map<String, TextEditingController> _controllers = {};

  final Map<String, double> _transportCarbonFactors = {
    'Taiwan Railway (km)': 0.06,
    'High-Speed Rail (km)': 0.032,
    'Private Car (km)': 0.173,
    'Motorcycle (km)': 0.06,
  };

  final Map<String, double> _drinkCarbonFactors = {
    'Milk Tea (300ml, tetra pack)': 0.016,
    'Black Tea (300ml, tetra pack)': 0.012,
    'Green Tea (300ml, tetra pack)': 0.013,
    'Cola (600ml, PET bottle)': 0.032,
    'Orange Juice (450ml, PET bottle)': 0.036,
    'Fresh Milk (litre)': 2.48,
  };

  double _totalTransportCarbonFootprint = 0.0;
  double _totalDrinkCarbonFootprint = 0.0;
  double _totalCarbonFootprint = 0.0;

  @override
  void initState() {
    super.initState();
    _transportCarbonFactors.keys.forEach((item) {
      _controllers[item] = TextEditingController(text: '0');
    });
    _drinkCarbonFactors.keys.forEach((item) {
      _controllers[item] = TextEditingController(text: '0');
    });
  }

  void _calculateCarbonFootprint() {
    double transportTotal = 0.0;
    double drinkTotal = 0.0;

    _transportCarbonFactors.forEach((item, factor) {
      final double quantity =
          double.tryParse(_controllers[item]?.text ?? '0') ?? 0.0;
      transportTotal += quantity * factor;
    });

    _drinkCarbonFactors.forEach((item, factor) {
      final double quantity =
          double.tryParse(_controllers[item]?.text ?? '0') ?? 0.0;
      drinkTotal += quantity * factor;
    });

    setState(() {
      _totalTransportCarbonFootprint = transportTotal;
      _totalDrinkCarbonFootprint = drinkTotal;
      _totalCarbonFootprint = transportTotal + drinkTotal;
    });
  }

  void _saveAndNavigateToCalendar() {
    _calculateCarbonFootprint(); // Calculate footprint before saving

    // Save each item with a positive quantity as a separate event
    final batch = FirebaseFirestore.instance.batch();
    final now = DateTime.now().toIso8601String();

    _transportCarbonFactors.keys.forEach((item) {
      final double quantity =
          double.tryParse(_controllers[item]?.text ?? '0') ?? 0.0;
      if (quantity > 0) {
        final eventDetails = '$item: $quantity';
        final newEvent = {
          'date': now, // or select a date
          'eventName': eventDetails,
          'carbonFootprint': quantity * _transportCarbonFactors[item]!,
          'transport carbon': _totalTransportCarbonFootprint,
          'drink carbon': _totalDrinkCarbonFootprint,
          'userEmail': FirebaseAuth.instance.currentUser?.email,
        };
        final docRef = FirebaseFirestore.instance.collection('events').doc();
        batch.set(docRef, newEvent);
      }
    });

    _drinkCarbonFactors.keys.forEach((item) {
      final double quantity =
          double.tryParse(_controllers[item]?.text ?? '0') ?? 0.0;
      if (quantity > 0) {
        final eventDetails = '$item: $quantity';
        final newEvent = {
          'date': now, // or select a date
          'eventName': eventDetails,
          'carbonFootprint': quantity * _drinkCarbonFactors[item]!,
          'transport carbon': _totalTransportCarbonFootprint,
          'drink carbon': _totalDrinkCarbonFootprint,
          'userEmail': FirebaseAuth.instance.currentUser?.email,
        };
        final docRef = FirebaseFirestore.instance.collection('events').doc();
        batch.set(docRef, newEvent);
      }
    });

    batch.commit().then((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeWidget()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Simple Calculator'),
      //   backgroundColor: Colors.green,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '簡易計算器',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 2, // 底線的高度
                color: const Color.fromARGB(115, 162, 161, 161), // 底線的顏色
                width: double.infinity, // 底線的寬度
              ),
              const SizedBox(height: 10),
              const Text(
                'Transport Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._transportCarbonFactors.keys.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _controllers[item],
                          decoration: InputDecoration(
                            labelText: item.contains('km') ? 'km' : 'units',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            labelStyle: TextStyle(color: Colors.green),
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 14),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              const Text(
                'Drink Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._drinkCarbonFactors.keys.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _controllers[item],
                          decoration: InputDecoration(
                            labelText:
                                item.contains('litre') ? 'litres' : 'units',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            labelStyle: TextStyle(color: Colors.green),
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 14),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateCarbonFootprint,
                child: const Text('Calculate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Carbon Footprint',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _totalCarbonFootprint.toStringAsFixed(3),
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' kg CO2',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Transport Carbon Footprint',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _totalTransportCarbonFootprint.toStringAsFixed(3),
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' kg CO2',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Drink Carbon Footprint',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _totalDrinkCarbonFootprint.toStringAsFixed(3),
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' kg CO2',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAndNavigateToCalendar,
                child: const Text('Add to Calendar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
