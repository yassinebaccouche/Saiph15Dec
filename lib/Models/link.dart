class Link {
  String id;
  String title;
  String link_url;
  Link({
    this.id='',
    required this.title,
    required this.link_url,
  });

  Map<String, dynamic> toJson() => {
    'id':id,
    'title':title,
    'link_url':link_url,
  };

  static Link fromJson(Map<String,dynamic> json) => Link (
    id: json['id'],
    title: json['title'],
    link_url: json['link_url'],
  );
}