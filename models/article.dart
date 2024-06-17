import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String? id;
  final String? title;
  final String? imageTitleUrl;
  final String? desc1;
  final String? descTitle1;
  final List<dynamic>? descImageUrl1;
  final String? desc2;
  final String? descTitle2;
  final List<dynamic>? descImageUrl2;
  final String? desc3;
  final String? descTitle3;
  final List<dynamic>? descImageUrl3;
  final String? desc4;
  final String? descTitle4;
  final List<dynamic>? descImageUrl4;
  final String? desc5;
  final String? descTitle5;
  final List<dynamic>? descImageUrl5;
  final String? desc6;
  final String? descTitle6;
  final List<dynamic>? descImageUrl6;
  final String? desc7;
  final String? descTitle7;
  final List<dynamic>? descImageUrl7;
  final String? desc8;
  final String? descTitle8;
  final List<dynamic>? descImageUrl8;
  final String? desc9;
  final String? descTitle9;
  final List<dynamic>? descImageUrl9;
  final String? desc10;
  final String? descTitle10;
  final List<dynamic>? descImageUrl10;
  final List<dynamic>? indexes;
  final String? categoryName;
  final String? sourceDesc;
  final bool? isActive;
  final dynamic likes;
  final int? likesCount;
  final String? language;
  final Timestamp? publishDate;
  final bool?
      isAdminTested; //değer "false" ise sadece admin görebilir makaleyi kontrol amaçlı.
  final String?
      ownerId; //ilerde diyetisyenler ve profesyonel kullanıcılarda yazı gönderebilir.
  Article(
      {this.id,
      this.title,
      this.imageTitleUrl,
      this.desc1,
      this.descTitle1,
      this.descImageUrl1,
      this.desc2,
      this.descTitle2,
      this.descImageUrl2,
      this.desc3,
      this.descTitle3,
      this.descImageUrl3,
      this.desc4,
      this.descTitle4,
      this.descImageUrl4,
      this.desc5,
      this.descTitle5,
      this.descImageUrl5,
      this.desc6,
      this.descTitle6,
      this.descImageUrl6,
      this.desc7,
      this.descTitle7,
      this.descImageUrl7,
      this.desc8,
      this.descTitle8,
      this.descImageUrl8,
      this.desc9,
      this.descTitle9,
      this.descImageUrl9,
      this.desc10,
      this.descTitle10,
      this.descImageUrl10,
      this.sourceDesc,
      this.isActive,
      this.likes,
      this.publishDate, //firestore a eklediğim tarih
      this.isAdminTested,
      this.ownerId,
      this.language,
      this.categoryName, //sağlık,beslenme,fitness
      this.likesCount,
      this.indexes});

  factory Article.fromDocument(DocumentSnapshot doc) {
    // print(doc);
    return Article(
        id: doc['id'],
        title: (doc.data() as Map).containsKey('title') ? doc['title'] : null,
        imageTitleUrl: (doc.data() as Map).containsKey('imageTitleUrl')
            ? doc['imageTitleUrl']
            : null,
        desc1: (doc.data() as Map).containsKey('desc1') ? doc['desc1'] : null,
        descTitle1: (doc.data() as Map).containsKey('descTitle1')
            ? doc['descTitle1']
            : null,
        descImageUrl1: (doc.data() as Map).containsKey('descImageUrl1')
            ? doc['descImageUrl1']
            : null,
        //descImageUrl1: doc['descImageUrl1'] ,
        desc2: (doc.data() as Map).containsKey('desc2') ? doc['desc2'] : null,
        descTitle2: (doc.data() as Map).containsKey('descTitle2')
            ? doc['descTitle2']
            : null,
        descImageUrl2: (doc.data() as Map).containsKey('descImageUrl2')
            ? doc['descImageUrl2']
            : null,
        desc3: (doc.data() as Map).containsKey('desc3') ? doc['desc3'] : null,
        descTitle3: (doc.data() as Map).containsKey('descTitle3')
            ? doc['descTitle3']
            : null,
        descImageUrl3: (doc.data() as Map).containsKey('descImageUrl3')
            ? doc['descImageUrl3']
            : null,
        desc4: (doc.data() as Map).containsKey('desc4') ? doc['desc4'] : null,
        descTitle4: (doc.data() as Map).containsKey('descTitle4')
            ? doc['descTitle4']
            : null,
        descImageUrl4: (doc.data() as Map).containsKey('descImageUrl4')
            ? doc['descImageUrl4']
            : null,
        desc5: (doc.data() as Map).containsKey('desc5') ? doc['desc5'] : null,
        descTitle5: (doc.data() as Map).containsKey('descTitle5')
            ? doc['descTitle5']
            : null,
        descImageUrl5: (doc.data() as Map).containsKey('descImageUrl5')
            ? doc['descImageUrl5']
            : null,
        desc6: (doc.data() as Map).containsKey('desc6') ? doc['desc6'] : null,
        descTitle6: (doc.data() as Map).containsKey('descTitle6')
            ? doc['descTitle6']
            : null,
        descImageUrl6: (doc.data() as Map).containsKey('descImageUrl6')
            ? doc['descImageUrl6']
            : null,
        desc7: (doc.data() as Map).containsKey('desc7') ? doc['desc7'] : null,
        descTitle7: (doc.data() as Map).containsKey('descTitle7')
            ? doc['descTitle7']
            : null,
        descImageUrl7: (doc.data() as Map).containsKey('descImageUrl7')
            ? doc['descImageUrl7']
            : null,
        desc8: (doc.data() as Map).containsKey('desc8') ? doc['desc8'] : null,
        descTitle8: (doc.data() as Map).containsKey('descTitle8')
            ? doc['descTitle8']
            : null,
        descImageUrl8: (doc.data() as Map).containsKey('descImageUrl8')
            ? doc['descImageUrl8']
            : null,
        desc9: (doc.data() as Map).containsKey('desc9') ? doc['desc9'] : null,
        descTitle9: (doc.data() as Map).containsKey('descTitle9')
            ? doc['descTitle9']
            : null,
        descImageUrl9: (doc.data() as Map).containsKey('descImageUrl9')
            ? doc['descImageUrl9']
            : null,
        desc10:
            (doc.data() as Map).containsKey('desc10') ? doc['desc10'] : null,
        descTitle10: (doc.data() as Map).containsKey('descTitle10')
            ? doc['descTitle10']
            : null,
        descImageUrl10: (doc.data() as Map).containsKey('descImageUrl10')
            ? doc['descImageUrl10']
            : null,
        sourceDesc: (doc.data() as Map).containsKey('sourceDesc')
            ? doc['sourceDesc']
            : null,
        isActive: (doc.data() as Map).containsKey('isActive')
            ? doc['isActive']
            : null,
        likes: (doc.data() as Map).containsKey('likes') ? doc['likes'] : null,
        publishDate: (doc.data() as Map).containsKey('publishDate')
            ? doc['publishDate']
            : null,
        isAdminTested: (doc.data() as Map).containsKey('isAdminTested')
            ? doc['isAdminTested']
            : null,
        ownerId:
            (doc.data() as Map).containsKey('ownerId') ? doc['ownerId'] : null,
        language: (doc.data() as Map).containsKey('language')
            ? doc['language']
            : null,
        categoryName: (doc.data() as Map).containsKey('categoryName')
            ? doc['categoryName']
            : null,
        indexes:
            (doc.data() as Map).containsKey('indexes') ? doc['indexes'] : null,
        likesCount: (doc.data() as Map).containsKey('likesCount')
            ? doc['likesCount']
            : "");
  }
}
