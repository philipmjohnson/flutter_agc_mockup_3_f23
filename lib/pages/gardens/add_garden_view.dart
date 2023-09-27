import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../components/help_button.dart';
import '../../data_model/chapter_db.dart';
import '../../data_model/garden_db.dart';
import '../../data_model/user_db.dart';
import 'form-fields/description_field.dart';
import 'form-fields/garden_name_field.dart';
import 'form-fields/utils.dart';
import 'gardens_view.dart';

/// Provides a page enabling the creation of a new Garden.
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Garden'),
          actions: const [HelpButton(routeName: AddGardenView.routeName)],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      GardenNameField(fieldKey: _nameFieldKey),
                      DescriptionField(fieldKey: _descriptionFieldKey),
                      FormBuilderDropdown<String>(
                        // autovalidate: true,
                        name: 'chapter',
                        key: _chapterFieldKey,
                        decoration: const InputDecoration(
                          labelText: 'Chapter',
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                        items: chapterNames
                            .map((name) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.centerStart,
                                  value: name,
                                  child: Text(name),
                                ))
                            .toList(),
                        valueTransformer: (val) => val?.toString(),
                      ),
                      FormBuilderTextField(
                        name: 'photo',
                        key: _photoFieldKey,
                        decoration: const InputDecoration(
                          labelText: 'Photo',
                          hintText:
                              'Example: garden-004.jpg (or garden-005.jpg)',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'editors',
                        key: _editorsFieldKey,
                        decoration: const InputDecoration(
                          labelText: 'Editor(s)',
                          hintText:
                              'An optional, comma separated list of usernames.',
                        ),
                        validator: (val) {
                          if (val is String) {
                            return validateUserNamesString(userDB, val);
                          }
                          return null;
                        },
                      ),
                      FormBuilderTextField(
                        name: 'viewers',
                        key: _viewersFieldKey,
                        decoration: const InputDecoration(
                          labelText: 'Viewer(s)',
                          hintText:
                              'An optional, comma separated list of usernames.',
                        ),
                        validator: (val) {
                          if (val is String) {
                            return validateUserNamesString(userDB, val);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          bool isValid =
                              _formKey.currentState?.saveAndValidate() ?? false;
                          if (isValid) {
                            // Extract garden data from fields
                            String name = _nameFieldKey.currentState?.value;
                            String description =
                                _descriptionFieldKey.currentState?.value;
                            String chapterID = chapterDB.getChapterIDFromName(
                                _chapterFieldKey.currentState?.value);
                            String imageFileName =
                                _photoFieldKey.currentState?.value;
                            String editorsString =
                                _editorsFieldKey.currentState?.value ?? '';
                            List<String> editorIDs =
                                usernamesToIDs(userDB, editorsString);
                            String viewersString =
                                _viewersFieldKey.currentState?.value ?? '';
                            List<String> viewerIDs =
                                usernamesToIDs(userDB, viewersString);
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
                            Navigator.pushReplacementNamed(
                                context, GardensView.routeName);
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                        },
                        // color: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          'Reset',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
