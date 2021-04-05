class AnnouncementModel {
  String announcementID;
  String announcementTitle;
  String announcementDescription;
  DateTime creationDate;
  DateTime expirationDate;

  AnnouncementModel({
    this.announcementID,
    this.announcementTitle,
    this.announcementDescription,
    this.creationDate,
    this.expirationDate,
  });

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    announcementID = json['announcementID'];
    announcementTitle = json['announcementTitle'];
    announcementDescription = json['announcementDescription'];
    creationDate = json['creationDate'];
    expirationDate = json['expirationDate'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['announcementID'] = this.announcementID;
    data['announcementTitle'] = this.announcementTitle;
    data['announcementDescription'] = this.announcementDescription;
    data['creationDate'] = this.creationDate;
    data['expirationDate'] = this.expirationDate;
    return data;
  }

}
