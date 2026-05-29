import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/announcement.dart';
class AnnouncementFormScreen extends StatefulWidget {
  final Announcement? existing; // null = create, not null = edit

  const AnnouncementFormScreen({super.key, required this.existing});

  @override
  State<AnnouncementFormScreen> createState() => _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState extends State<AnnouncementFormScreen> {

  String title = "";
  String body = "";
  String? selectedCategory;
  bool isPinned = false;

  final List<String> categories = ["Info", "Event", "Emergency", "Health"];

  @override
  void initState() {
    super.initState();

     if (widget.existing != null) {
      title = widget.existing!.title;
      body = widget.existing!.body;
      selectedCategory = widget.existing!.category;
      isPinned = widget.existing!.isPinned;
     }
  }

   void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void cancel() {
    Navigator.pop(context); // send nothing back
  }

  void save() {
    if (title.trim().isEmpty){
      showMessage("Title is required");
      return;
    }

    if (body.trim().isEmpty){
      showMessage("Body is required");
      return;
    }

    if (selectedCategory == null){
      showMessage("Please pick a category");
      return;
    }

   if (widget.existing == null){
    Uuid uuid = Uuid();
      Announcement newItem = Announcement(
        id: uuid.v4(),
        title: title,
        body: body,
        category: selectedCategory!,
        datePosted: DateTime.now(),
        isPinned: isPinned,
      );
      Navigator.pop(context, newItem); // send it back to the list
    }

    else{
      Announcement item = widget.existing!;
      item.title = title;
      item.body = body;
      item.category = selectedCategory!;
      item.isPinned = isPinned;
      Navigator.pop(context, item);
    }
  }


  @override
  Widget build(BuildContext context) {
    String screenTitle = "New Announcement";
    if (widget.existing != null) {
      screenTitle = "Edit Announcement";
  }


   List<DropdownMenuItem<String>> categoryItems = [];
    for (String c in categories) {
      categoryItems.add(
        DropdownMenuItem(value: c, child: Text(c)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            initialValue: title,
            maxLength: 120,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              title = value;
            },
          ),

          SizedBox(height: 12),

          TextFormField(
            initialValue: body,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "Body",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              body = value;
            },
          ),

          SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(),
            ),
            items: categoryItems,
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
              },
          ),

          SizedBox(height: 8),

          SwitchListTile(
            title: Text("Pin this announcement"),
            value: isPinned,
            onChanged: (value) {
              setState(() {
                isPinned = value;
              });
            },
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: cancel,
                  child: Text("Cancel"),
                ),
                ),

              SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: save,
                  child: Text("Save"),
                ),
                ),
            ],
            ),
        ],
    ),
  
  );
  }
}