import 'package:flutter/material.dart';

Widget buildBottomSheet(BuildContext context,
    {required Function onTap,
    required TextEditingController titleController,
    required String titleText,
    required String buttonText}) {
  return Padding(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      top: 16,
      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              titleText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Color(0xff031956)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Color(0xff031956))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Color(0xff031956)))),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffA1C0F8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xff031956)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    onTap();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff031956),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(color: Color(0xffA1C0F8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
