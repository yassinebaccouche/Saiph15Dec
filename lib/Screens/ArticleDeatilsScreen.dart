import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysaiph/Screens/QuizArticleScreen.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:mysaiph/providers/user_provider.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> articleData;

  const ArticleDetailsScreen({Key? key, required this.articleData})
      : super(key: key);

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  final FireStoreMethodes _fireStoreMethodes = FireStoreMethodes();
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        currentUserId = userProvider.getUser.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 10,
            backgroundColor: Colors.blueAccent,
            title: const Text(
              'Détails de l`article',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author and date information
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.articleData['profImage']),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.articleData['pseudo'] ?? "Anonymous",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat.yMMMMEEEEd().format(
                                    widget.articleData['datePublished'].toDate(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8), Center(
                    child: Text(
                      '${widget.articleData['Title']}?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  // Article image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.articleData['postUrl'],
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Article question text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${widget.articleData['question']}?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Article description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.articleData['description'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Article hint text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        widget.articleData['Hint'] ?? '',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Button to take the quiz
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Retrieve all responses for the current article.

                            bool hasResponded = await _fireStoreMethodes.hasUserResponded(
                                currentUserId,
                                widget.articleData['articleId']
                            );

                            if (hasResponded) {
                              // Show a message that the user has already responded.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Vous avez déjà répondu à cet article"),
                                ),
                              );

                          } else {
                            // If not, navigate to the ArticleQuizScreen.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleQuizScreen(
                                  articleId: widget.articleData['articleId'],
                                  question: widget.articleData['question'],
                                  points:widget.articleData['points'],
                                  possibleAnswers: List<String>.from(widget.articleData['possibleAnswers']),
                                  correctAnswer: widget.articleData['correctAnswer'], quizBackgroundUrl: widget.articleData['quizBackgroundUrl'],

                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Passer au Quiz >',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Footer image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/taarafchi.png',
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
