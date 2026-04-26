import 'package:flutter/material.dart';
import 'long_button.dart'; // Assuming your LongButton is in the same folder

/// Displays a modal bottom sheet that rises from the bottom.
///
/// Contains two text fields and a "Done" button.
/// The [onDone] callback receives the values from the two text fields.
void showPopupTab(BuildContext context,
    {required Function(String, String) onDone}) {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  showModalBottomSheet(
    context: context,
    // isScrollControlled allows the sheet to be taller and avoids the keyboard
    isScrollControlled: true,
    // Give it a rounded top shape
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      // Use Padding to respect the keyboard's view insets
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Make the sheet only as tall as its content
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Title for the pop-up
            const Text(
              'Enter Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // First Text Field
            TextField(
              controller: controller1,
              decoration: const InputDecoration(
                labelText: 'Detail 1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Second Text Field
            TextField(
              controller: controller2,
              decoration: const InputDecoration(
                labelText: 'Detail 2',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Done Button
            LongButton(
              text: "Done",
              onPressed: () {
                // Pass the text field values back through the callback
                onDone(controller1.text, controller2.text);
                // Close the bottom sheet
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24), // Spacing at the bottom
          ],
        ),
      );
    },
  );
}