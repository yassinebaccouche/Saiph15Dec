import 'package:flutter/material.dart';
import 'package:mysaiph/models/link.dart';
import 'package:mysaiph/services/link_service.dart';
import 'package:mysaiph/Screens/link_item.dart';

class LinksListScreen extends StatefulWidget {
  const LinksListScreen({Key? key}) : super(key: key);

  @override
  State<LinksListScreen> createState() => _LinksListScreenState();
}

class _LinksListScreenState extends State<LinksListScreen> {
  final LinkService linkService = LinkService();
  late bool isLoading;
  late bool isError;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;
  }

  // Remove the fetchLinks() method that was using .first. You can now directly listen to the stream in the build method.

  Future<void> _refreshLinks() async {
    setState(() {
      isLoading = true;  // Set loading to true when refreshing
    });
    // If you need to refresh manually, you can use this. Otherwise, the stream already handles real-time updates.
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = false;  // Stop the loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00B2FF),
        title: const Text(
          'Liens',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xff273085),
        onRefresh: _refreshLinks,
        child: StreamBuilder<List<Link>>(
          stream: linkService.fetchLinks(), // Listen to the stream here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xfff5f5f5)));
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Une erreur s\'est produite'),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _refreshLinks, // Retry fetching the data
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun lien n\'a été ajouté'));
            }

            // Now that we're listening to the stream, this will automatically rebuild when links change.
            final linkInputs = snapshot.data!;
            return ListView.builder(
              itemCount: linkInputs.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: LinkItem(link: linkInputs[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
