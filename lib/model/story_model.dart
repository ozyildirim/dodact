class StoryModel {
  String type;
  String photoURL;
  int viewCounter;
  int rank;

  StoryModel({this.type, this.photoURL, this.viewCounter, this.rank});

  StoryModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    photoURL = json['photoURL'];
    viewCounter = json['view_counter'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['type'] = this.type;
    data['photoURL'] = this.photoURL;
    data['view_counter'] = this.viewCounter;
    data['rank'] = this.rank;
    return data;
  }
}
