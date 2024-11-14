import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(List<String>) onSelectedItemsChanged;

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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.text.isNotEmpty) {
        _onSearchChanged(widget.controller.text);
      } else {
        setState(() {
          inventorySuggestions = [];
        });
      }
    });
  }

  // Debounce function
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchInventorySuggestions(query);
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
        final dynamic data = json.decode(response.body);

        if (data is List) {
          if (data.isNotEmpty && data.first is String) {
            return List<String>.from(data);
          }
          return data.map<String>((item) => item['name'] as String).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void _addItem(String item) {
    if (!selectedItems.contains(item)) {
      setState(() {
        selectedItems.add(item);
        widget.onSelectedItemsChanged(selectedItems); // Update parent widget
        widget.controller.clear(); // Clear the input after adding an item
        inventorySuggestions = []; // Clear suggestions
      });
    }
  }

  void _removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
      widget.onSelectedItemsChanged(selectedItems); // Update parent widget
    });
  }

  // Method to handle custom part name input
  void _handleCustomPartName() {
    String customPartName = widget.controller.text.trim();
    if (customPartName.isNotEmpty && !selectedItems.contains(customPartName)) {
      _addItem(customPartName);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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
          onSubmitted: (_) {
            // Add the custom part name when the user presses 'Enter'
            _handleCustomPartName();
          },
        ),
        // Show suggestions only if there are suggestions
        if (inventorySuggestions.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: inventorySuggestions.map((item) {
              return ListTile(
                title: Text(item),
                onTap: () => _addItem(item),
              );
            }).toList(),
          ),
        // Show "No suggestions" if no suggestions are found
        if (inventorySuggestions.isEmpty && widget.controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "No suggestions found. You can enter a custom part name.",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
      ],
    );
  }
}
