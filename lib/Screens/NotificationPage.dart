import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mysaiph/Models/Notif.dart';
import 'package:mysaiph/Screens/display_notif.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [];
  late String currentUserId;
  bool isLoading = true;
  final FireStoreMethodes _fireStoreMethodes = FireStoreMethodes();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUserId = userProvider.getUser.uid;
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // Fetch user's responses
      final responseSnapshot = await FirebaseFirestore.instance
          .collection('notifResponse')
          .where('uid', isEqualTo: currentUserId)
          .get();

      // Get responded notification IDs
      final respondedIds = responseSnapshot.docs
          .map((doc) => doc['notifId'] as String)
          .toSet();

      // Fetch all notifications
      final notifSnapshot =
      await FirebaseFirestore.instance.collection('notifications').get();

      // Convert and filter notifications
      final allNotifications = notifSnapshot.docs
          .map((doc) => NotificationModel.fromSnap(doc))
          .toList();

      final filteredNotifications = allNotifications
          .where((notif) => !respondedIds.contains(notif.NotifId)) // lowercase
          .toList();

      setState(() {
        notifications = filteredNotifications;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF00B2FF),
      ),
      body: RefreshIndicator(
        onRefresh: fetchNotifications, // Refresh method
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
            ? const Center(child: Text('Aucune notification disponible'))
            : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GestureDetector(
                onTap: () async {
                  final hasResponded = await _fireStoreMethodes.hasUserRespondedNotif(
                    currentUserId,
                    notification.NotifId, // lowercase
                  );

                  if (hasResponded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vous avez déjà répondu à cette notification"),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayNotificationPage(
                          notification: notification,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      notification.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "voir details", // lowercase
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF00B2FF),
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF00B2FF)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
