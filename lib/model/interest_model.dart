class Interest {
  String interestCategory;
  List<String> interestSubcategory;
  String experience;

  Interest({this.interestCategory, this.interestSubcategory, this.experience});

  Interest.fromJson(Map<String, dynamic> json) {
    interestCategory = json['interestCategory'];
    interestSubcategory = json['interestSubcategory'].cast<String>();
    experience = json['experience'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['interestCategory'] = this.interestCategory;
    data['interestSubcategory'] = this.interestSubcategory;
    data['experience'] = this.experience;
    return data;
  }
}
