import 'package:get_storage/get_storage.dart';

class UserPaymentObject {
  final _box = GetStorage();

  int get clientId {
    return _box.read('clientId') ?? 0;
  }

  set clientId(int value) {
    _box.write('clientId', value);
  }

  int get scheduleId {
    return _box.read('scheduleId') ?? 0;
  }

  set scheduleId(int value) {
    _box.write('scheduleId', value);
  }

  String get dateval {
    return _box.read('dateval') ?? '';
  }

  set dateval(String value) {
    _box.write('dateval', value);
  }

  String get time {
    return _box.read('time') ?? '';
  }

  set time(String value) {
    _box.write('time', value);
  }

  String get paypaltoken {
    return _box.read('paypaltoken') ?? '';
  }

  set paypaltoken(String value) {
    _box.write('paypaltoken', value);
  }

  double get userfee {
    return _box.read('userfee') ?? 0.0;
  }

  set userfee(double value) {
    _box.write('userfee', value);
  }

  double get taxfee {
    return _box.read('taxfee') ?? 0;
  }

  set taxfee(double value) {
    _box.write('taxfee', value);
  }

  double get platformfee {
    return _box.read('platformfee') ?? 0;
  }

  set platformfee(double value) {
    _box.write('platformfee', value);
  }

  double get totalfee {
    return _box.read('totalfee') ?? 0;
  }

  set totalfee(double value) {
    _box.write('totalfee', value);
  }

  int get profileId {
    return _box.read('profileId') ?? 0;
  }

  set profileId(int value) {
    _box.write('profileId', value);
  }

  String get profileType {
    return _box.read('profileType') ?? '';
  }

  set profileType(String value) {
    _box.write('profileType', value);
  }

  String get title {
    return _box.read('title') ?? '';
  }

  set title(String value) {
    _box.write('title', value);
  }

  String get profilename {
    return _box.read('profilename') ?? '';
  }

  set profilename(String value) {
    _box.write('profilename', value);
  }

  String get realdate {
    return _box.read('realdate') ?? '';
  }

  set realdate(String value) {
    _box.write('realdate', value);
  }

  void clear() {
    _box.write('clientId', 0);
    _box.write('scheduleId', 0);
    _box.write('dateval', '');
    _box.write('time', '');
    _box.write('paypaltoken', '');
    _box.write('userfee', 0);
    _box.write('taxfee', 0.0);
    _box.write('platformfee', 0.0);
    _box.write('totalfee', 0.0);
    _box.write('profileId', 0);
    _box.write('profileType', '');
    _box.write('title', '');
    _box.write('profilename', '');
    _box.write('realdate', '');
  }
}
