import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'field_padding.dart';

/// A text field to support defining new or revised garden names.
class DescriptionField extends StatelessWidget {
  const DescriptionField(
      {super.key, required this.fieldKey, this.currDescription});

  final String? currDescription;
  final GlobalKey<FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
      fieldKey;

  @override
  Widget build(BuildContext context) {
    String fieldName = 'Description';
    return FieldPadding(
      child: FormBuilderTextField(
        name: fieldName,
        key: fieldKey,
        initialValue: currDescription,
        decoration: InputDecoration(
          labelText: fieldName,
          hintText: 'Example: "19 Beds, 162 Plantings (2022)"',
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
    );
  }
}
