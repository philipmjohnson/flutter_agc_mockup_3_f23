import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'field_padding.dart';

/// A dropdown allowing the user to specify a chapter.
class ChapterDropdownField extends StatelessWidget {
  const ChapterDropdownField(
      {super.key,
      required this.fieldKey,
      required this.chapterNames,
      this.currChapter});

  final String? currChapter;
  final List<String> chapterNames;
  final GlobalKey<FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
      fieldKey;

  @override
  Widget build(BuildContext context) {
    String fieldName = 'Chapter';
    return FieldPadding(
      child: FormBuilderDropdown<String>(
        name: fieldName,
        initialValue: currChapter,
        key: fieldKey,
        decoration: InputDecoration(
          labelText: fieldName,
        ),
        validator:
            FormBuilderValidators.compose([FormBuilderValidators.required()]),
        items: chapterNames
            .map((name) => DropdownMenuItem(
                  alignment: AlignmentDirectional.centerStart,
                  value: name,
                  child: Text(name),
                ))
            .toList(),
        valueTransformer: (val) => val?.toString(),
      ),
    );
  }
}
