

class GoogleRoute {
  int second;
  String polyLine;

  GoogleRoute(this.second, this.polyLine);

  factory GoogleRoute.fromJson(Map<String, dynamic> json) {
    var sec = (json['routes']['duration'] as String);
    var second = int.tryParse(sec.substring(0, sec.length)) ?? -1;
    var polyLine = json['routes']['polyline'] as String;

    return GoogleRoute(second, polyLine);
  }

}