import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> events = [];

  final _eventNameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> fetchEvents() async {
    try {
      // Update with your actual backend URL & endpoint
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/events'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        // Handle error
        debugPrint('Failed to load events');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
    }
  }

  Future<bool> addEvent(String name, String location, DateTime date) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/events'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'location': location,
          'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error adding event: $e');
      return false;
    }
  }

  Future<void> _showAddEventDialog() async {
    _eventNameController.clear();
    _locationController.clear();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add New Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _eventNameController,
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                      ),
                    ),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          selectedDate?.toLocal().toString().split(' ')[0] ??
                              'No Date chosen!',
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setStateDialog(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: const Text('Select Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cancel dialog
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_eventNameController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    bool success = await addEvent(
                      _eventNameController.text,
                      _locationController.text,
                      selectedDate!,
                    );

                    if (success) {
                      Navigator.of(context).pop();
                      fetchEvents(); // Refresh the event list
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add event')),
                      );
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Page'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
            events.isEmpty
                ? const Center(
                  child: Text(
                    'No live events yet.\nTap + to add one!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(
                          Icons.event_available,
                          color: Colors.red[700],
                        ),
                        title: Text(
                          event['name'] ?? 'Unknown Event',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${event['location'] ?? 'Unknown Location'}\n${formatDate(event['date'] ?? '')}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        tooltip: 'Add Event',
      ),
    );
  }
}
