import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Future<void> showExitPopup(
    {context,
    String? text,
    Function()? onpressed,
    Function()? onpressed1}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: const Color.fromARGB(255, 235, 29, 14),
                child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 235, 29, 14),
                  radius: 30,
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 40,
                  ),
                )),
            const SizedBox(height: 20),
            Text(
              "$text ?",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            Text(
              "Are you sure, You want to $text ?",
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 128, 128, 128)),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: onpressed,
                    child: Text("$text"),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 65, 105, 119),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onpressed1,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Color.fromARGB(255, 41, 93, 112)),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 236, 248, 252),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
