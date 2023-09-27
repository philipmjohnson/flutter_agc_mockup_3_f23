import '../../../data_model/user_db.dart';

/// Return null if the username string is valid, otherwise return an error message.
validateUserNamesString(UserDB userDB, String val) {
  if (val.isEmpty) {
    return null;
  }
  List<String> userNames = val.split(',').map((val) => val.trim()).toList();
  if (!userDB.areUserNames(userNames)) {
    return 'Non-existent user name(s)';
  }
  return null;
}

/// Convert the list of usernames to userIDs.
List<String> usernamesToIDs(UserDB userDB, String usernamesString) {
  if (usernamesString.isEmpty) {
    return [];
  }
  List<String> usernames =
      usernamesString.split(',').map((editor) => editor.trim()).toList();
  return usernames.map((username) => userDB.getUserID(username)).toList();
}
