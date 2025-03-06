import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/link.dart';

class LinkService {
  final CollectionReference _linksCollection = FirebaseFirestore.instance.collection('links');

  // Create a new link
  Future<void> createLink(String title, String link_url) async {
    final newLinkDoc = _linksCollection.doc();
    final link = Link(title: title, link_url: link_url, id: newLinkDoc.id);
    await newLinkDoc.set(link.toJson());
  }

  // Fetch links with real-time updates
  Stream<List<Link>> fetchLinks() {
    return _linksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Ensure data is correctly parsed as a Map
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return Link.fromJson(data);
        } else {
          // Return a default or handle the case when data is null
          return Link(id: doc.id, title: '', link_url: ''); // Example of a default link
        }
      }).toList();
    });
  }

  // Update an existing link
  Future<void> updateLink(String id, String title, String link_url) async {
    await _linksCollection.doc(id).update({
      'title': title,
      'link_url': link_url,
    });
  }

  // Delete a link
  Future<void> deleteLink(String id) async {
    await _linksCollection.doc(id).delete();
  }
}

