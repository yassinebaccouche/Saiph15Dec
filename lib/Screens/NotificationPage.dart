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
  late String currentUserId; // Declare this as a late variable
  bool isLoading = true; // Track loading state
  final FireStoreMethodes _fireStoreMethodes = FireStoreMethodes();

  @override
  void initState() {
    super.initState();
    // Fetch notifications when the widget is initialized
    fetchNotifications();

    // Using post-frame callback to get the user ID after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        currentUserId = userProvider.getUser.uid;
      });
    });
  }

  // Function to fetch notifications from Firestore
  Future<void> fetchNotifications() async {
    try {
      List<NotificationModel> fetchedNotifications =
      await _fireStoreMethodes.fetchAllNotifications();

      setState(() {
        notifications = fetchedNotifications;
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false even on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching notifications: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEFF1),
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF00B2FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildNotificationList(),
    );
  }

  // Widget to build the notification list view
  Widget buildNotificationList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        NotificationModel notification = notifications[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GestureDetector(
            onTap: () async {
              bool hasResponded = await _fireStoreMethodes.hasUserRespondedNotif(
                currentUserId,
                notification.NotifId, // Make sure 'NotifId' is the correct field name
              );

              if (hasResponded) {
                // If the user has responded, show a snack bar message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Vous avez déjà répondu à cette notification"),
                  ),
                );
              } else {
                // If the user hasn't responded, navigate to the details page
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
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  notification.question,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Appuyez pour afficher les détails',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF00B2FF),
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF00B2FF)),
              ),
            ),
          ),
        );
      },
    );
  }
}
