

class Spotlight {
  final int spotLightCount ;
  List<dynamic> data  ;

  Spotlight({ this.spotLightCount, this.data});

  factory Spotlight.fromJson(Map<String, dynamic> json) {
    return Spotlight(
        spotLightCount : json['data'],
        data: json['data1']
    );
  }
}

class SpotLightImage {
  String originalPath;
  String FullPath;

  SpotLightImage({this.FullPath, this.originalPath});
}