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

List<String> categoryList = [
  "Tiyatro",
  "Çini",
  "Pandomim",
  "Bachata",
  "Tango",
  "Salsa",
  "Portre Çizim",
  "Fotoğrafçılık",
  "Karakalem",
  "Heykel",
  "Minyatür",
  "Kabartma",
  "Porselen",
  "Çömlek",
  "Vitray",
  "Ahşap Oyma",
  "Çizim",
  "Karikatür",
  "Batik",
  "Tiyatr1o",
  "Çi1ni",
  "Pa1ndomim",
  "Bac1hata",
  "Tan1go",
  "Sal1sa",
  "Por1tre Çizim",
  "Fot1oğraf",
  "Ka1rakalem",
  "He1ykel",
  "Min1yatür",
  "Kab1artma",
  "Po1rselen",
  "Çö1mlek",
  "Vi1tray",
  "Ah11şap Oyma",
  "Çiz11im",
  "Kar1ikatür",
  "Bati1k",
  "Tiyat2r1o",
  "Çi12ni",
  "Pa12ndomim",
  "Bac12hata",
  "Tan21go",
  "Sal21sa",
  "Por21tre Çizim",
  "Fot12oğraf",
  "Ka1r2akalem",
  "He1y2kel",
  "Min12yatür",
  "Kab21artma",
  "Po1rse2len",
  "Çö1m2lek",
  "Vi1t2ray",
  "Ah121şap Oyma",
  "Çiz121im",
  "Kar12ikatür",
  "Bat2i1k",
];
