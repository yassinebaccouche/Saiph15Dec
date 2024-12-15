import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Models/movie.dart';
import '../../../services/movies_service.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(onTap: (){
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
          "MySaiph Films",
          style: TextStyle(color: Color(0xFF273085)),
        ),
        backgroundColor: const Color(0xFFFCFCFC),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:  EdgeInsets.all(15.0),
                    child: Text(
                      "Populaires",
                      style: TextStyle(color: Color(0xFF273085), fontSize: 17),
                    ),
                  ),
                  FutureBuilder(
                    future: MovieService.getPopularMovies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        List<Movie>? movies = snapshot.data;

                        return moviesList(screenHeight,screenWidth,movies);
                      }
                    },
                  ),
                  const Padding(
                    padding:  EdgeInsets.all(15.0),
                    child: Text(
                      "Les mieux notés",
                      style: TextStyle(color: Color(0xFF273085), fontSize: 17),
                    ),
                  ),
                  FutureBuilder(
                    future: MovieService.getTopRatedMovies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        List<Movie>? movies = snapshot.data;

                        return moviesList(screenHeight,screenWidth,movies);
                      }
                    },
                  ),
                  const Padding(
                    padding:  EdgeInsets.all(15.0),
                    child: Text(
                      "Prochainement",
                      style: TextStyle(color: Color(0xFF273085), fontSize: 17),
                    ),
                  ),
                  FutureBuilder(
                    future: MovieService.getUpcomingMovies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        List<Movie>? movies = snapshot.data;

                        return moviesList(screenHeight,screenWidth,movies);
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  SizedBox moviesList(double screenHeight,double screenWidth,List<Movie>? movies, ){
    return SizedBox(
        height: screenHeight / 3,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies?.length,
          itemBuilder: (context, index) {
            if (movies != null) {
              Movie movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(
                          movie: movie,
                        ),
                      ));
                },
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12)),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(12),
                        child: Image.network(
                          movie.imageUrl!,
                          fit: BoxFit.cover,
                          height: screenHeight / 3 - 50,
                          width: screenWidth / 2.5,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: screenWidth / 2.5 - 20,
                        child: Center(
                            child: Text(movie.name!,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color(
                                        0xFF273085))))),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_border_outlined,
                          color: Color(0xFF273085),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                            movie.rating!.substring(0, 3),
                            style: const TextStyle(
                                color: Color(0xFF273085)))
                      ],
                    )
                  ],
                ),
              );
            }
            return null;
          },
        ));
  }
}
