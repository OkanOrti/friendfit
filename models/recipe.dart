import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String? id;
  final String? title;
  final String? imageTitleUrl;
  final String? ingredientTitle;
  final List<dynamic>? ingredients;
  final List<dynamic>? method1;
  final List<dynamic>? method2;
  final List<dynamic>? method3;
  final String? methodTitle1;
  final String? methodTitle2;
  final String? methodTitle3;
  final String? calorie;
  final String? preperationTime;
  final String? cookingTime;
  final String? serves;
  final String? categoryName; //veganlar için çocuklar için gibi..
  final String? sourceDesc;
  final bool? isActive;
  final dynamic likes;
  final int? likesCount;
  final String? language;
  final Timestamp? publishDate;
  final bool?
      isAdminTested; //değer "false" ise sadece admin görebilir makaleyi kontrol amaçlı.
  final String? ownerId;
  final List<dynamic>?
      indexes; //ilerde diyetisyenler ve profesyonel kullanıcılarda yazı gönderebilir.
  Recipe(
      {this.id,
      this.title,
      this.imageTitleUrl,
      this.calorie,
      this.cookingTime,
      this.ingredients,
      this.ingredientTitle,
      this.method1,
      this.method2,
      this.method3,
      this.methodTitle1,
      this.methodTitle2,
      this.methodTitle3,
      this.preperationTime,
      this.serves,
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

  factory Recipe.fromDocument(DocumentSnapshot doc) {
    //print(doc);
    return Recipe(
        id: doc['id'],
        title: (doc.data() as Map).containsKey('title') ? doc['title'] : null,
        imageTitleUrl: (doc.data() as Map).containsKey('imageTitleUrl')
            ? doc['imageTitleUrl']
            : null,
        calorie:
            (doc.data() as Map).containsKey('calorie') ? doc['calorie'] : null,
        cookingTime: (doc.data() as Map).containsKey('cookingTime')
            ? doc['cookingTime']
            : null,
        ingredients: (doc.data() as Map).containsKey('ingredients')
            ? doc['ingredients']
            : null,
        ingredientTitle: (doc.data() as Map).containsKey('ingredientTitle')
            ? doc['ingredientTitle']
            : null,
        method1:
            (doc.data() as Map).containsKey('method1') ? doc['method1'] : null,
        method2:
            (doc.data() as Map).containsKey('method2') ? doc['method2'] : null,
        method3:
            (doc.data() as Map).containsKey('method3') ? doc['method3'] : null,
        methodTitle1: (doc.data() as Map).containsKey('methodTitle1')
            ? doc['methodTitle1']
            : null,
        methodTitle2: (doc.data() as Map).containsKey('methodTitle2')
            ? doc['methodTitle2']
            : null,
        methodTitle3: (doc.data() as Map).containsKey('methodTitle3')
            ? doc['methodTitle3']
            : null,
        preperationTime: (doc.data() as Map).containsKey('preperationTime')
            ? doc['preperationTime']
            : null,
        serves:
            (doc.data() as Map).containsKey('serves') ? doc['serves'] : null,
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
            : null);
  }
}
