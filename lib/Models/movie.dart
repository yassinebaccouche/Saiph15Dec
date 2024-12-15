class Movie {
  String? name;
  String? desc;
  String? imageUrl;
  String? rating;
  String? year;
  List<int>? genres;
  Movie({
    this.name,
    this.desc,
    this.imageUrl,
    this.rating,
    this.year,
  });

  Movie.fromJson(Map<String,dynamic> json){
    List<int> _genres=[];
    name=json['title'];
    desc=json['overview'];
    imageUrl="https://image.tmdb.org/t/p/w500${json['poster_path']}";
    rating=json['vote_average'].toString();
    year=json['release_date'];
    for (var element in (json['genre_ids'] as List<dynamic>)) {_genres.add(element);}
    genres=_genres;
  }
}
