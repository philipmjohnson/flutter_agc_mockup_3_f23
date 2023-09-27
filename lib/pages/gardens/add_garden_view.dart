import 'package:flutter/material.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/editors_field.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/photo_field.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/reset_button.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/submit_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/help_button.dart';
import '../../data_model/chapter_db.dart';
import '../../data_model/garden_db.dart';
import '../../data_model/user_db.dart';
import 'form-fields/chapter_dropdown_field.dart';
import 'form-fields/description_field.dart';
import 'form-fields/garden_name_field.dart';
import 'form-fields/utils.dart';
import 'form-fields/viewers_field.dart';
import 'gardens_view.dart';

/// Create a new Garden.
class AddGardenView extends ConsumerWidget {
  AddGardenView({Key? key}) : super(key: key);

  static const routeName = '/addGardenView';
  final _formKey = GlobalKey<FormBuilderState>();
  final _nameFieldKey = GlobalKey<FormBuilderFieldState>();
  final _descriptionFieldKey = GlobalKey<FormBuilderFieldState>();
  final _chapterFieldKey = GlobalKey<FormBuilderFieldState>();
  final _photoFieldKey = GlobalKey<FormBuilderFieldState>();
  final _editorsFieldKey = GlobalKey<FormBuilderFieldState>();
  final _viewersFieldKey = GlobalKey<FormBuilderFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChapterDB chapterDB = ref.watch(chapterDBProvider);
    final UserDB userDB = ref.watch(userDBProvider);
    final GardenDB gardenDB = ref.watch(gardenDBProvider);
    final String currentUserID = ref.watch(currentUserIDProvider);
    List<String> chapterNames = chapterDB.getChapterNames();

    void onSubmit() {
      bool isValid = _formKey.currentState?.saveAndValidate() ?? false;
      if (!isValid) return;
      // Since validation passed, we can safely access the values.
      String name = _nameFieldKey.currentState?.value;
      String description = _descriptionFieldKey.currentState?.value;
      String chapterID =
          chapterDB.getChapterIDFromName(_chapterFieldKey.currentState?.value);
      String imageFileName = _photoFieldKey.currentState?.value;
      String editorsString = _editorsFieldKey.currentState?.value ?? '';
      List<String> editorIDs = usernamesToIDs(userDB, editorsString);
      String viewersString = _viewersFieldKey.currentState?.value ?? '';
      List<String> viewerIDs = usernamesToIDs(userDB, viewersString);
      // Add the new garden.
      gardenDB.addGarden(
          name: name,
          description: description,
          chapterID: chapterID,
          imageFileName: imageFileName,
          editorIDs: editorIDs,
          ownerID: currentUserID,
          viewerIDs: viewerIDs);
      // Return to the list gardens page
      Navigator.pushReplacementNamed(context, GardensView.routeName);
    }

    void onReset() {
      _formKey.currentState?.reset();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Garden'),
          actions: const [HelpButton(routeName: AddGardenView.routeName)],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      GardenNameField(fieldKey: _nameFieldKey),
                      DescriptionField(fieldKey: _descriptionFieldKey),
                      ChapterDropdownField(
                          fieldKey: _chapterFieldKey,
                          chapterNames: chapterNames),
                      PhotoField(fieldKey: _photoFieldKey),
                      EditorsField(fieldKey: _editorsFieldKey, userDB: userDB),
                      ViewersField(fieldKey: _viewersFieldKey, userDB: userDB),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SubmitButton(onSubmit: onSubmit),
                    ResetButton(onReset: onReset),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
