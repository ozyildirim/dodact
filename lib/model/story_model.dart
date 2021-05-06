class StoryModel {
  String id;
  String type;
  String photoURL;
  int viewCounter;

  StoryModel({this.id, this.type, this.photoURL, this.viewCounter});

  StoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    photoURL = json['photoURL'];
    viewCounter = json['view_counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['photoURL'] = this.photoURL;
    data['view_counter'] = this.viewCounter;
    return data;
  }
}
