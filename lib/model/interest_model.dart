class InterestModel {
  String interestId;
  String interestCategory;
  String interestSubcategory;

  InterestModel(
      {this.interestId, this.interestCategory, this.interestSubcategory});

  InterestModel.fromJson(Map<String, dynamic> json) {
    interestId = json["interest_id"];
    interestCategory = json['interestCategory'];
    interestSubcategory = json['interestSubcategory'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["interestId"] = interestId;
    data['interestCategory'] = this.interestCategory;
    data['interestSubcategory'] = this.interestSubcategory;

    return data;
  }
}
