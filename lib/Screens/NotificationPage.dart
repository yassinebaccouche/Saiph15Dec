import 'package:flutter/material.dart';
import 'package:mysaiph/Models/Notif.dart';
import 'package:mysaiph/Screens/display_notif.dart';
import 'package:mysaiph/resources/firestore_methods.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    FireStoreMethodes firestoreMethods = FireStoreMethodes();
    List<NotificationModel> fetchedNotifications =
    await firestoreMethods.fetchAllNotifications();

    setState(() {
      notifications = fetchedNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEFF1), // Background color
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF00B2FF), // App bar color
      ),
      body: buildNotificationList(),
    );
  }

  Widget buildNotificationList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        NotificationModel notification = notifications[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GestureDetector(
            onTap: () {
              // Navigate to the detail page with the selected notification
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayNotificationPage(
                    notification: notification,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Card background color
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
                    color: Colors.black87, // Text color
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Appuyez pour afficher les détails',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600], // Subtitle text color
                    ),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF00B2FF), // Circle avatar background color
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white, // Icon color
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF00B2FF), // Arrow icon color
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
