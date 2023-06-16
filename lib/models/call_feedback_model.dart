class CallFeedBackModel {
  String _starttime;
  String _endtime;
  int _talkcount;
  int _totalhours;
  double _rating;
  String _professionalId;
  String _calluserId;
  String _comments;

  CallFeedBackModel({
    required String starttime,
    required String endtime,
    required int talkcount,
    required int totalhours,
    required double rating,
    required String professionalId,
    required String calluserId,
    required String comments,
  })  : _starttime = starttime,
        _endtime = endtime,
        _talkcount = talkcount,
        _totalhours = totalhours,
        _rating = rating,
        _professionalId = professionalId,
        _calluserId = calluserId,
        _comments = comments;

  String get starttime => _starttime;
  set starttime(String value) => _starttime = value;

  String get endtime => _endtime;
  set endtime(String value) => _endtime = value;

  int get talkcount => _talkcount;
  set talkcount(int value) => _talkcount = value;

  int get totalhours => _totalhours;
  set totalhours(int value) => _totalhours = value;

  double get rating => _rating;
  set rating(double value) => _rating = value;

  String get professionalId => _professionalId;
  set professionalId(String value) => _professionalId = value;

  String get calluserId => _calluserId;
  set calluserId(String value) => _calluserId = value;

  String get comments => _comments;
  set comments(String value) => _comments = value;

  factory CallFeedBackModel.fromJson(Map<String, dynamic> json) {
    return CallFeedBackModel(
      starttime: json['starttime'],
      endtime: json['endtime'],
      talkcount: json['talkcount'],
      totalhours: json['totalhours'],
      rating: json['rating'],
      professionalId: json['professionalId'],
      calluserId: json['calluserId'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starttime': _starttime,
      'endtime': _endtime,
      'talkcount': _talkcount,
      'totalhours': _totalhours,
      'rating': _rating,
      'professionalId': _professionalId,
      'calluserId': _calluserId,
      'comments': _comments,
    };
  }
}
