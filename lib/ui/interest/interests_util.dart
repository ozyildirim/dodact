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

List<InterestType> categoryList = [
  new InterestType(
      id: "0",
      name: "Tiyatro",
      coverPhotoUrl: "assets/images/app/interests/tiyatro.jpeg",
      subCategories: [
        "Doğaçlama",
        "Tülüat",
        "Yazılı Metin",
        "Radyo Tiyatrosu",
        "Pandomim"
      ]),
  new InterestType(
      id: "1",
      name: "Müzik",
      coverPhotoUrl: "assets/images/app/interests/muzik.jpeg",
      subCategories: [
        "Müzik",
        "Kültür",
        "Müzikal",
        "Müzikalizm",
        "Müzikal Dünyası"
      ]),
  new InterestType(
      id: "2",
      name: "Dans",
      coverPhotoUrl: "assets/images/app/interests/dans.jpeg",
      subCategories: ["Dans1", "Dans2", "Dans3", "Dans4", "Dans5"]),
  new InterestType(
      id: "3",
      name: "Görsel Sanatlar",
      coverPhotoUrl: "assets/images/app/interests/gorsel_sanatlar.jpeg",
      subCategories: [
        "Graffiti",
        "Illustrasyon",
        "Portre",
        "Anıt Heykeller",
        "Karikatür",
        "İllustrasyon",
        "Manga",
        "Animasyon",
        "Çizgi Roman",
        "Anime",
      ])
];
