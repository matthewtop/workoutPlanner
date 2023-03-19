//todaysdate
String todaysDate() {
  var dateTimeObject = DateTime.now();

  String year = dateTimeObject.year.toString();

  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  //final format
  String ddmmyyyy = day + month + year;
  return ddmmyyyy;
}

//converting into datetime object
DateTime createDateTimeObject(String ddmmyyyy) {
  int dd = int.parse(ddmmyyyy.substring(0, 2));
  int mm = int.parse(ddmmyyyy.substring(2, 4));
  int yyyy = int.parse(ddmmyyyy.substring(4, 8));
  DateTime dateTimeObject = DateTime(dd, mm, yyyy);
  return dateTimeObject;
}

String convertDateTimeToDDMMYYYY(DateTime dateTime) {
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String year = dateTime.year.toString();
  //final format
  String ddmmyyyy = day + month + year;
  return ddmmyyyy;
}
