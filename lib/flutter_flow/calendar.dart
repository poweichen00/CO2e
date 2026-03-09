import 'package:c_o2e/flutter_flow/flutter_flow_theme.dart';
import 'package:c_o2e/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();
  TextEditingController _carbonFootprintController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  List<Event> _events = [];
  double _totalCarbonFootprint = 0.0;
  bool _hasShownPreviousDayFootprint = false; // 追蹤對話框是否已經顯示過

  Future<void> _loadShownFootprintStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasShownPreviousDayFootprint =
        prefs.getBool('hasShownPreviousDayFootprint') ?? false;
  }

  Future<void> _setShownFootprintStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShownPreviousDayFootprint', status);
  }

  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = _selectedDay;
    _loadEventsForDay(_selectedDay);
    _updateTotalCarbonFootprint(); // Fetch total carbon footprint
    _loadShownFootprintStatus();
    _showPreviousDayCarbonFootprint(); // 在初始化时显示前一天的碳足迹对话框
  }

  void _updateTotalCarbonFootprint() async {
    double total = await _getTotalCarbonFootprint();
    if (mounted) {
      setState(() {
        _totalCarbonFootprint = total;
      });
    }
  }

  Future<void> _showPreviousDayCarbonFootprint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the last shown timestamp from SharedPreferences
    int? lastShownTimestamp = prefs.getInt('lastShownTimestamp');
    DateTime now = DateTime.now();

    if (lastShownTimestamp != null) {
      DateTime lastShownTime = DateTime.fromMillisecondsSinceEpoch(lastShownTimestamp);
      // If less than an hour has passed since the last notification, do nothing
      if (now.difference(lastShownTime).inHours < 24) {
        return;
      }
    }

    DateTime previousDay = _selectedDay.subtract(Duration(days: 1));
    double totalPreviousDayFootprint = await _getCarbonFootprintForDay(previousDay);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('昨日的碳足跡'),
            content: Text(
              '你${previousDay.toIso8601String().split('T').first} 的碳足跡為 ${totalPreviousDayFootprint.toStringAsFixed(2)} kg CO2',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    // Update the last shown time in SharedPreferences
    await prefs.setInt('lastShownTimestamp', now.millisecondsSinceEpoch);
  }

  Future<double> _getCarbonFootprintForDay(DateTime day) async {
    try {
      String dayString = DateTime(day.year, day.month, day.day)
          .toIso8601String()
          .split('T')
          .first;

      final snapshot = await _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: dayString)
          .where('date', isLessThan: '${dayString}T23:59:59.999Z')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      double totalCarbonFootprint = snapshot.docs.fold(0.0, (sum, doc) {
        return sum + (doc['carbonFootprint'] as double? ?? 0.0);
      });

      return totalCarbonFootprint;
    } catch (e) {
      print('Error fetching carbon footprint for day: $e');
      return 0.0;
    }
  }

  Future<double> _getTotalCarbonFootprint() async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('userEmail', isEqualTo: userEmail) // Filter by user
          .get();

      double totalCarbonFootprint = snapshot.docs.fold(0.0, (sum, doc) {
        return sum + (doc['carbonFootprint'] as double? ?? 0.0);
      });

      return totalCarbonFootprint;
    } catch (e) {
      print('Error fetching total carbon footprint: $e');
      return 0.0;
    }
  }

  @override
  void dispose() {
    _eventController.dispose();
    _carbonFootprintController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _loadEventsForDay(selectedDay);
        _showPreviousDayCarbonFootprint(); // 每次选择日期时检查并显示前一天的碳足迹
      });
    }
  }


  Future<void> _loadEventsForDay(DateTime day) async {
    List<Event> events = await _getEventsForDay(day);
    if (mounted) {
      setState(() {
        _events = events;
      });
      print(
          'Events loaded for ${day.toIso8601String()}: ${events.map((e) => e.eventName).toList()}');
    }
  }

  Future<List<Event>> _getEventsForDay(DateTime day) async {
    try {
      String dayString = DateTime(day.year, day.month, day.day)
          .toIso8601String()
          .split('T')
          .first;

      final snapshot = await _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: dayString)
          .where('date', isLessThan: '${dayString}T23:59:59.999Z')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  void _editEvent(String eventId) async {
    if (_eventController.text.isNotEmpty &&
        _isNumeric(_carbonFootprintController.text)) {
      double carbonFootprint = double.parse(_carbonFootprintController.text);

      await _firestore.collection('events').doc(eventId).update({
        'eventName': _eventController.text,
        'carbonFootprint': carbonFootprint,
      });

      _eventController.clear();
      _carbonFootprintController.clear();
      Navigator.pop(context);
      _loadEventsForDay(_selectedDay);
    }
  }

  void _deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
    Navigator.pop(context);
    _loadEventsForDay(_selectedDay);
  }

  Future<void> _showEventDialog({Event? event}) async {
    if (event != null) {
      _eventController.text = event.eventName;
      _carbonFootprintController.text = event.carbonFootprint.toString();
    } else {
      _eventController.clear();
      _carbonFootprintController.clear();
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(event != null ? "Edit Event" : "手動添加紀錄"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _eventController,
                decoration: const InputDecoration(
                  hintText: '輸入名稱',
                ),
              ),
              TextField(
                controller: _carbonFootprintController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '輸入碳足跡',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            if (event != null) ...[
              TextButton(
                child: Text('DELETE'),
                onPressed: () {
                  _deleteEvent(event.id);
                },
              ),
              TextButton(
                child: Text('SAVE'),
                onPressed: () {
                  _editEvent(event.id);
                },
              ),
            ] else ...[
              TextButton(
                child: Text('SAVE'),
                onPressed: () {
                  _addEvent();
                },
              ),
            ],
          ],
        );
      },
    );
  }

  void _addEvent() async {
    if (_eventController.text.isNotEmpty &&
        _isNumeric(_carbonFootprintController.text)) {
      double carbonFootprint = double.parse(_carbonFootprintController.text);

      await _firestore.collection('events').add({
        'date':
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)
                .toIso8601String(),
        'eventName': _eventController.text,
        'carbonFootprint': carbonFootprint,
        'userEmail': userEmail,
      });

      _eventController.clear();
      _carbonFootprintController.clear();
      Navigator.pop(context);
      _loadEventsForDay(_selectedDay);
    }
  }

  Widget _buildEventsMarker(DateTime date, List<Event> events) {
    if (events.isEmpty) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Calendar'),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //       child: Center(
      //         child: Text(
      //           'Total: ${_totalCarbonFootprint.toStringAsFixed(2)} kg CO2',
      //           style: TextStyle(fontSize: 16),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _showEventDialog();
              },
              child: Icon(Icons.add),
              heroTag: 'addEvent',
              backgroundColor: const Color.fromARGB(255, 89, 145, 90),
            ),
          ),
          Positioned(
            bottom: 90,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                context.pushNamed('chat_ai_Screen');
              },
              child: Icon(Icons.sms),
              heroTag: 'goAi',
              backgroundColor: const Color.fromARGB(255, 89, 145, 90),
            ),
          ),
          Positioned(
            bottom: 170,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                context.pushNamed('action_home');
              },
              child: Icon(Icons.task_alt_sharp),
              heroTag: 'goAction',
              backgroundColor: const Color.fromARGB(255, 89, 145, 90),
            ),
          ),
          // Positioned(
          //   bottom: 250,
          //   right: 16,
          //   child: FloatingActionButton(
          //     onPressed: () async {
          //       context.pushNamed('action_home');
          //     },
          //     child: Icon(Icons.task_alt_sharp),
          //     heroTag: 'goAction',
          //   ),
          // ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Carbon Footprint:',
                  style: FlutterFlowTheme.of(context).headlineMedium,
                ),
                Text(
                  '${_totalCarbonFootprint.toStringAsFixed(2)} kg CO2e',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
          ),
          Container(
            height: 2, // 底線的高度
            color: const Color.fromARGB(115, 162, 161, 161), // 底線的顏色
            width: double.infinity, // 底線的寬度
          ),
          TableCalendar(
            locale: "en_US",
            rowHeight: 60,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 10, 10),
            lastDay: DateTime.utc(2030, 10, 10),
            onDaySelected: _onDaySelected,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final eventList = events.cast<Event>();
                if (eventList.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, eventList),
                  );
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event.eventName),
                  subtitle:
                      Text('Carbon Footprint: ${event.carbonFootprint} kg CO2'),
                  onTap: () {
                    _showEventDialog(event: event);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
