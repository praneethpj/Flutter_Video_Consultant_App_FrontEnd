import '../constants/AlertType.dart';

class AlertModel {
  int id;
  AlertType alertType;
  String title;
  String message;
  String datetime;

  AlertModel(
      {required this.id,
      required this.alertType,
      required this.title,
      required this.message,
      required this.datetime});
}
