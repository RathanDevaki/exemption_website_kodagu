class District {
  String distId;
  String distName;

  District({this.distId, this.distName});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      distId: json['dist_id'] as String,
      distName: json['dist_name'] as String,
    );
  }
}
