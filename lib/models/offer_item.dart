import 'package:cached_network_image/cached_network_image.dart';

class OfferItem {
  String ownerUid;
  String itemId;
  String title;
  String description;
  List<dynamic> images;
  String price;

  OfferItem(
      {this.ownerUid,
      this.itemId,
      this.title,
      this.description,
      this.images,
      this.price});

  OfferItem.fromSnapshot(String key, dynamic value)
      : itemId = key,
        ownerUid = value['ownerUid'].toString(),
        title = value['title'].toString(),
        description = value['description'].toString(),
        images = value['images'],
        price = value['price'].toString();

  List<dynamic> getNetworkImagesAsArray() {
    List<dynamic> list = new List<dynamic>();
    images.forEach((img) => list.add(CachedNetworkImageProvider(img)));
    return list;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
}
