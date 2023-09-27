import 'package:flutter/material.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/chapter_dropdown_field.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/description_field.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/editors_field.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/garden_name_field.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/photo_field.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/reset_button.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/submit_button.dart';
import 'package:flutter_agc_mockup/pages/gardens/form-fields/viewers_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/help_button.dart';
import '../../data_model/chapter_db.dart';
import '../../data_model/garden_db.dart';
import '../../data_model/user_db.dart';
import 'form-fields/utils.dart';
import 'gardens_view.dart';

/// Edit data for a specific garden.
class EditGardenView extends ConsumerWidget {
  EditGardenView({Key? key}) : super(key: key);

  static const routeName = '/editGardenView';
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
    String gardenID = ModalRoute.of(context)!.settings.arguments as String;
    GardenData gardenData = gardenDB.getGarden(gardenID);
    List<String> chapterNames = chapterDB.getChapterNames();
    String currChapterName = chapterDB.getChapter(gardenData.chapterID).name;
    String currEditors = gardenData.editorIDs
        .map((userID) => userDB.getUser(userID).username)
        .toList()
        .join(', ');
    String currViewers = gardenData.viewerIDs
        .map((userID) => userDB.getUser(userID).username)
        .toList()
        .join(', ');

    void onSubmit() {
      bool isValid = _formKey.currentState?.saveAndValidate() ?? false;
      if (!isValid) return;
      // Valid so update the garden data.
      String name = _nameFieldKey.currentState?.value;
      String description = _descriptionFieldKey.currentState?.value;
      String chapterID =
          chapterDB.getChapterIDFromName(_chapterFieldKey.currentState?.value);
      String imagePath = _photoFieldKey.currentState?.value;
      String editorsString = _editorsFieldKey.currentState?.value ?? '';
      List<String> editorIDs = usernamesToIDs(userDB, editorsString);
      String viewersString = _viewersFieldKey.currentState?.value ?? '';
      List<String> viewerIDs = usernamesToIDs(userDB, viewersString);
      // Update the garden data.
      gardenDB.updateGarden(
          id: gardenID,
          name: name,
          description: description,
          chapterID: chapterID,
          imagePath: imagePath,
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
          title: const Text('Edit Garden'),
          actions: const [HelpButton(routeName: EditGardenView.routeName)],
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
                      GardenNameField(
                          fieldKey: _nameFieldKey, currName: gardenData.name),
                      DescriptionField(
                          fieldKey: _descriptionFieldKey,
                          currDescription: gardenData.description),
                      ChapterDropdownField(
                          fieldKey: _chapterFieldKey,
                          chapterNames: chapterNames,
                          currChapter: currChapterName),
                      PhotoField(
                          fieldKey: _photoFieldKey,
                          currPhoto: gardenData.imagePath),
                      EditorsField(
                          fieldKey: _editorsFieldKey,
                          userDB: userDB,
                          currEditors: currEditors),
                      ViewersField(
                          fieldKey: _viewersFieldKey,
                          userDB: userDB,
                          currViewers: currViewers),
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
