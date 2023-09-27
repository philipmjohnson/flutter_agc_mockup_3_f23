import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../data_model/user_db.dart';
import 'field_padding.dart';
import 'utils.dart';

/// A text field to input garden photo file name found in images subdirectory.
class ViewersField extends StatelessWidget {
  const ViewersField(
      {super.key,
      required this.fieldKey,
      required this.userDB,
      this.currViewers});

  final String? currViewers;
  final UserDB userDB;
  final GlobalKey<FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
      fieldKey;

  @override
  Widget build(BuildContext context) {
    String fieldName = 'Viewers';
    return FieldPadding(
      child: FormBuilderTextField(
        name: fieldName,
        key: fieldKey,
        initialValue: currViewers,
        decoration: InputDecoration(
          labelText: fieldName,
          hintText: 'An optional, comma separated list of usernames.',
        ),
        validator: (val) {
          if (val is String) {
            return validateUserNamesString(userDB, val);
          }
          return null;
        },
      ),
    );
  }
}
