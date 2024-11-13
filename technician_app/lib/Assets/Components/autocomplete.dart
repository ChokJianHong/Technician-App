<<<<<<< Updated upstream
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
=======
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
>>>>>>> Stashed changes

class MyAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
<<<<<<< Updated upstream
  final Function(List<String>)
      onSelectedItemsChanged; // Callback to pass selected items
=======
>>>>>>> Stashed changes

  const MyAutocomplete({
    required this.controller,
    required this.hintText,
<<<<<<< Updated upstream
    required this.onSelectedItemsChanged,
=======
>>>>>>> Stashed changes
    super.key,
  });

  @override
  _MyAutocompleteState createState() => _MyAutocompleteState();
}

class _MyAutocompleteState extends State<MyAutocomplete> {
  List<String> inventorySuggestions = [];
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.text.isNotEmpty) {
        _fetchInventorySuggestions(widget.controller.text);
      } else {
        setState(() {
          inventorySuggestions = [];
        });
      }
    });
  }

  Future<void> _fetchInventorySuggestions(String query) async {
    List<String> suggestions = await fetchInventoryFromDatabase(query);
    setState(() {
      inventorySuggestions = suggestions;
    });
  }

<<<<<<< Updated upstream
  Future<List<String>> fetchInventoryFromDatabase(String query) async {
    final url = Uri.parse(
        'http://10.0.2.2:5005/dashboarddatabase/inventoryName?query=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final dynamic data = json.decode(response.body);

        if (data is List) {
          if (data.isNotEmpty && data.first is String) {
            return List<String>.from(data);
          }
          return data.map<String>((item) => item['name'] as String).toList();
        } else {
          print('Unexpected data format');
          return [];
        }
=======
  // Function to fetch inventory data from your backend
  Future<List<String>> fetchInventoryFromDatabase(String query) async {
    final url =
        Uri.parse('http://your-backend-url.com/api/inventory?query=$query');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Extract inventory item names (adjust the key based on your JSON structure)
        return data.map<String>((item) => item['name'] as String).toList();
>>>>>>> Stashed changes
      } else {
        print('Failed to load inventory suggestions');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  void _addItem(String item) {
    if (!selectedItems.contains(item)) {
      setState(() {
        selectedItems.add(item);
<<<<<<< Updated upstream
        widget.onSelectedItemsChanged(selectedItems); // Update parent widget
        widget.controller.clear(); // Clear the input after adding an item
=======
        widget.controller.clear();
>>>>>>> Stashed changes
        inventorySuggestions = [];
      });
    }
  }

  void _removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
<<<<<<< Updated upstream
      widget.onSelectedItemsChanged(selectedItems); // Update parent widget
=======
>>>>>>> Stashed changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
<<<<<<< Updated upstream
        Wrap(
          spacing: 8.0,
          children: selectedItems.map((item) {
            return Chip(
              label: Text(item),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () => _removeItem(item),
            );
          }).toList(),
        ),
=======
>>>>>>> Stashed changes
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
<<<<<<< Updated upstream
          ),
          onChanged: (text) {
            if (text.isNotEmpty) {
              _fetchInventorySuggestions(text);
            }
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: inventorySuggestions.map((item) {
            return ListTile(
              title: Text(item),
              onTap: () => _addItem(item),
            );
          }).toList(),
        ),
      ],
    );
  }
=======
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _fetchInventorySuggestions(widget.controller.text);
              },
            ),
          ),
        ),
        if (inventorySuggestions.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: inventorySuggestions.map((suggestion) {
                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    _addItem(suggestion);
                  },
                );
              }).toList(),
            ),
          ),
        Wrap(
          spacing: 5,
          children: selectedItems.map((item) {
            return Chip(
              label: Text(item),
              onDeleted: () {
                _removeItem(item);
              },
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            _submitSelectedItems();
          },
          child: Text("Submit Items"),
        ),
      ],
    );
  }

  Future<void> _submitSelectedItems() async {
    await sendItemsToDatabase(selectedItems);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Items submitted: ${selectedItems.join(', ')}")),
    );
  }

  Future<void> sendItemsToDatabase(List<String> items) async {
    // Example implementation of sending items to the backend
    final url = Uri.parse('http://your-backend-url.com/api/submit-items');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"items": items}),
      );

      if (response.statusCode == 200) {
        print("Items submitted successfully");
      } else {
        print("Failed to submit items");
      }
    } catch (e) {
      print("Error submitting items: $e");
    }
  }
>>>>>>> Stashed changes
}
