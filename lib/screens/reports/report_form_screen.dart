import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/issue_report.dart';

class ReportFormScreen extends StatefulWidget {
  final IssueReport? existing;

  const ReportFormScreen({super.key, required this.existing});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {

  String title = "";
  String description = "";
  String? selectedCategory;
  String selectedStatus = "Pending";

  final List<String> categories = ["Road", "Power", "Water", "Safety", "Other"];
  final List<String> statuses = ["Pending", "In Progress", "Resolved"];

  @override
  void initState() {
    super.initState();

    if (widget.existing != null){
      title = widget.existing!.title;
      description = widget.existing!.description;
      selectedCategory = widget.existing!.category;
      selectedStatus = widget.existing!.status;
        }
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
        );
  }

  void save() {
    if (title.trim().isEmpty){
      showMessage("Title is required");
      return;
    }

    if (description.trim().isEmpty){
      showMessage("Description is required");
      return;
    }

    if (selectedCategory == null){
      showMessage("Please pick a category");
      return;
    }

    if (widget.existing == null){
      Uuid uuid = Uuid();

      IssueReport newItem = IssueReport(
        id: uuid.v4(),
        title: title,
        description: description,
        category: selectedCategory!,
        status: selectedStatus,
        dateReported: DateTime.now(),
          );

      Navigator.pop(context, newItem);
    }
    else{
      IssueReport item = widget.existing!;
      item.title = title;
      item.description = description;
      item.category = selectedCategory!;
      item.status = selectedStatus;

      Navigator.pop(context, item);
        }
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String screenTitle = "New Report";
    if (widget.existing != null){
      screenTitle = "Edit Report";
    }

    List<DropdownMenuItem<String>> categoryItems = [];
    for (String c in categories) {
      categoryItems.add(DropdownMenuItem(value: c, child: Text(c)));
    }

    List<DropdownMenuItem<String>> statusItems = [];
    for (String s in statuses) {
      statusItems.add(DropdownMenuItem(value: s, child: Text(s)));
    }

    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [ TextFormField(
          initialValue: title,
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
            initialValue: description,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              description = value;
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

          SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: selectedStatus,
            decoration: InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(),
            ),
            items: statusItems,
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
              ),

          SizedBox(height: 20),

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