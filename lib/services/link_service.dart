import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/link.dart';

class LinkService {

  final CollectionReference _linksCollection = FirebaseFirestore.instance.collection('links');

  Future<void> createLink(String title, String link_url) async {
    final newLinkDoc = _linksCollection.doc();
    final link = Link(title: title, link_url: link_url, id: newLinkDoc.id);
    await newLinkDoc.set(link.toJson());
  }

  Stream<List<Link>> fetchLinks(){
    return _linksCollection.snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Link.fromJson(doc.data()! as Map<String, dynamic>))
        .toList());
  }

  Future<void> updateLink(String id, String title, String link_url) async {
    await _linksCollection.doc(id).update({
      'title':title,
      'link_url':link_url,
    });
  }

  Future<void> deleteLink(String id) async {
    await _linksCollection.doc(id).delete();
  }

}