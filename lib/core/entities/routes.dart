

class GoogleRoute {
  int second;
  String polyLine;

  GoogleRoute(this.second, this.polyLine);

  factory GoogleRoute.fromJson(Map<String, dynamic> json) {
    // print("masuk ke factory");
    // print("json : ${json['routes'][0]['duration']}");
    if (json.isEmpty) {
      print("masuk ke error");
      return GoogleRoute(-1, "");
    } else {
      var sec = json['routes'][0]['duration'] as String;


      var second = int.tryParse(sec.substring(0, sec.length - 1)) ?? -1;

      // print("poly: ${json['routes'][0]['polyline']["encodedPolyline"]}");

      var polyLine = json['routes'][0]['polyline']["encodedPolyline"] as String;

      return GoogleRoute(second, polyLine);
    }
  }

}