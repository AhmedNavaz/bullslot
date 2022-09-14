class Utils {
  String getRemainingTime(DateTime date) {
    var hours = date.difference(DateTime.now()).inHours;
    var minutes = date.difference(DateTime.now()).inMinutes % 60;
    var seconds = date.difference(DateTime.now()).inSeconds % 60;
    String remaining = '$hours:'.padLeft(3, '0') +
        '$minutes:'.padLeft(3, '0') +
        '$seconds'.padLeft(2, '0');
    if (remaining.contains('-')) {
      return '00:00:00';
    }
    return remaining;
  }
}
