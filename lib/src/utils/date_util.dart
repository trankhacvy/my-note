var monthsNames = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "July",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
];

String getFormattedDate(int dueDate) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(dueDate);
  return "${monthsNames[date.month - 1]} ${date.day}, ${date.year} at ${date.hour > 9 ? '' : '0'}${date.hour}:${date.minute > 9 ? '' : '0'}${date.minute}";
}