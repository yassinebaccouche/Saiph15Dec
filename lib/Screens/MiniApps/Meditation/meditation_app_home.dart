import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../services/api_quote.dart';
import 'list_item.dart';

class MeditationHomePage extends StatelessWidget {
  const MeditationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                "assets/images/close_icon.svg",
                width: 25,
              ),
            ),
          )
        ],
        elevation: 0,
        title: const Text(
          "MySaiph Méditation",
          style: TextStyle(color: Color(0xFF273085)),
        ),
        backgroundColor: const Color(0xFFFCFCFC),
      ),
      body: FutureBuilder<String>(
        future: QuoteService.getQuote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF273085),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Tout les jours sont une bonne journée",
                    style: TextStyle(color: Color(0xFF273085), fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    width: screenWidth,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFF273085)),
                    child: Column(
                      children: [
                        const Text(
                          "Citation du jour",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    snapshot.data ??
                                        "Impossible d'obtenir des données",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: SvgPicture.asset(
                                  "assets/images/citation.svg",
                                  width: screenWidth / 3,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          listItem(context, 'assets/images/relaxing.jpg',
                              'Relaxant'),
                          const SizedBox(
                            height: 20,
                          ),
                          listItem(
                              context, 'assets/images/healing.jpg', 'Guérison'),
                          const SizedBox(
                            height: 20,
                          ),
                          listItem(
                              context, 'assets/images/sleeping.jpg', 'Sommeil'),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    ));
  }
}
