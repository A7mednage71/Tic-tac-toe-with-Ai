List<int> findEmptyFields(List<String> ticBoard) {
  List<int> emptyFields = [];
  for (int i = 0; i < ticBoard.length; i++) {
    if (ticBoard[i] == '') {
      emptyFields.add(i);
    }
  }
  return emptyFields;
}
