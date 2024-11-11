import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const MyAutocomplete({
    required this.controller,
    required this.hintText,
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

  // Function to fetch inventory data from your backend
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
        widget.controller.text = item;
        widget.controller.selection =
            TextSelection.collapsed(offset: item.length);
        inventorySuggestions = [];
      });
    }
  }

  void _removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
    });
  }

  // Method to generate the string of all selected items
  String getSelectedItemsString() {
    return selectedItems.join(', '); // Concatenate items with a comma separator
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _fetchInventorySuggestions(widget.controller.text);
              },
            ),
          ),
        ),
        if (inventorySuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
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

      ],
    );
  }
}
