class InterestType {
  String id;
  String name;
  String coverPhotoUrl;
  List<String> subCategories;

  InterestType(
      {String id,
      String name,
      String coverPhotoUrl,
      List<String> subCategories}) {
    this.id = id;
    this.name = name;
    this.coverPhotoUrl = coverPhotoUrl;
    this.subCategories = subCategories;
  }
}

List<InterestType> interestCategoryList = [
  new InterestType(
      id: "0",
      name: "Sahne Sanatları",
      coverPhotoUrl: "assets/images/app/interests/tiyatro.jpeg",
      subCategories: [
        'Tiyatro',
        'Opera',
        'Gölge Oyunu',
        'Sinema',
        'Bale',
        'Dans',
        'Pandomim',
        'Müzikal',
        'Kukla'
      ]),
  new InterestType(
      id: "1",
      name: "Yüzey Sanatları",
      coverPhotoUrl: "assets/images/app/interests/gorsel_sanatlar.jpeg",
      subCategories: [
        'Çizim',
        'Karakalem',
        'Karikatür',
        'Batik',
        'Süsleme',
        'Duvar Resmi',
        'Yağlı Boya',
        'Sulu Boya',
        'Fotoğraf',
        'Minyatür',
        'Hat',
        'Ebru',
      ]),
  new InterestType(
      id: "2",
      name: "Hacim Sanatları",
      coverPhotoUrl: "assets/images/app/interests/volume_arts.jpg",
      subCategories: [
        'Heykel',
        'Kabartma',
        'Porselen',
        'Çini',
        'Çömlek',
        'Vitray',
        'Ahşap Oyma',
      ]),
  new InterestType(
      id: "3",
      name: "Ses Sanatları",
      coverPhotoUrl: "assets/images/app/interests/muzik.jpeg",
      subCategories: [
        'Müzik',
      ])
];
