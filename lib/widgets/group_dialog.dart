import 'package:flutter/material.dart';

import '../models/user.dart';
import '../service/database_service.dart';
import 'widgets.dart';

class MyAlertDialog extends StatefulWidget {
  final AppUser user;

  const MyAlertDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final formKey = GlobalKey<FormState>();
  bool _dialogLoading = false;

  late String groupName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AlertDialog(
        title: const Text(
          "Create a group",
          textAlign: TextAlign.center,
        ),
        content: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.group,
                      color: Colors.redAccent,
                    ),
                  ),
                  onChanged: (value) {
                     groupName = value;
                  },
                  validator: (v) {
                    return (v!.isEmpty) ? "Please enter your full name" : null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[900],
                        ),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              _dialogLoading = true;
                            });

                            await DatabaseService(uId: widget.user.uId)
                                .savingGroupData(groupName, widget.user.fullName)
                                .then((value) {
                              setState(() {
                                _dialogLoading = false;
                              });
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[900],
                        ),
                        child: const Text("Create")),
                  ],
                ),
              ],
            ),
            if (_dialogLoading)
              Container(

                height: 120,
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
