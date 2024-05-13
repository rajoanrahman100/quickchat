class Validator{
  ///Add Note Title Validator
  static String? validateNoteTitle(String value) {
    if (value.isEmpty) {
      return "Please enter a title for your note.";
    }
    return null;
  }

  ///Add Note Content Validator
  static String? validateNoteContent(String value) {
    if (value.isEmpty) {
      return "Please enter the content of your note.";
    }
    return null;
  }
}