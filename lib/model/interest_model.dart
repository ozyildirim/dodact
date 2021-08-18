class Interest {
  String interestCategory;
  List<String> interestSubcategory;

  Interest({this.interestCategory, this.interestSubcategory});

  Interest.fromJson(Map<String, dynamic> json) {
    interestCategory = json['interestCategory'];
    interestSubcategory = json['interestSubcategory'].cast<String>();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['interestCategory'] = this.interestCategory;
    data['interestSubcategory'] = this.interestSubcategory;

    return data;
  }
}
