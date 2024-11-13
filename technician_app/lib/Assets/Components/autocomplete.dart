import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(List<String>)
      onSelectedItemsChanged; // Callback to pass selected items

  const MyAutocomplete({
    required this.controller,
    required this.hintText,
    required this.onSelectedItemsChanged,
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
        widget.onSelectedItemsChanged(selectedItems); // Update parent widget
        widget.controller.clear(); // Clear the input after adding an item
        inventorySuggestions = [];
      });
    }
  }

  void _removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
      widget.onSelectedItemsChanged(selectedItems); // Update parent widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
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
}
