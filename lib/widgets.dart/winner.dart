bool win(List<String> ticBoard, String player) {
  List<List<int>> winConditions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  for (var state in winConditions) {
    if (ticBoard[state[0]] == player &&
        ticBoard[state[1]] == player &&
        ticBoard[state[2]] == player) {
      return true;
    }
  }
  return false;
}
