import 'package:flutter/material.dart';

import '../../../Models/movie.dart';
import '../../../services/movies_service.dart';


class MovieDetail extends StatelessWidget {
  final Movie movie;

  const MovieDetail({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(children: [
        Stack(
          children: [
            Image.network(movie.imageUrl!, fit: BoxFit.fill),
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF273085).withOpacity(0.1),
                        const  Color(0xFF273085).withOpacity(0.1),
                        const Color(0xFF273085).withOpacity(0.9),
                        const Color(0xFF273085),
                        const Color(0xFF273085),
                  ])),
              child: FutureBuilder(
                future: MovieService.getCategories(movie.genres!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<String>? categ = snapshot.data;
                    if (categ != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.name!,
                              style:
                              const TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                                children: List.generate(
                                    categ.length,
                                    (index) => Text(
                                          index != (categ.length - 1)
                                              ? "${categ[index]}, "
                                              : categ[index],
                                          style: const TextStyle(color: Colors.grey),
                                        ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              movie.desc!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Chip(avatar: const Icon(
                                    Icons.not_interested_rounded,
                                    color: Color(0xFF273085),
                                  ),
                                    label: Text(
                                        "+${int.parse(movie.rating!.substring(0, 1)) + 5}",
                                        style: const TextStyle(
                                            color: Color(0xFF273085))),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Chip(avatar: const Icon(
                                    Icons.calendar_month_rounded,
                                    color: Color(0xFF273085),
                                  ),
                                    label: Text(movie.year!.substring(0, 4),
                                        style: const TextStyle(
                                            color: Color(0xFF273085))),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Chip(
                                    avatar: const Icon(
                                      Icons.star_border_outlined,
                                      color: Color(0xFF273085),
                                    ),
                                    label: Text(
                                      movie.rating!.substring(0, 3),
                                      style:
                                      const TextStyle(color: Color(0xFF273085)),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: Text("cannot get data"),
                    );
                  }
                },
              ),
            ),
            Positioned(
                child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: Color(0xFF273085),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            )),
          ],
        )
      ]),
    );
  }
}
