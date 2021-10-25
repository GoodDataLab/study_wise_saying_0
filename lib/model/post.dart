class Post {
  String? id;
  String? title;
  String? content;
  String? subtitle;
  DateTime? dateCreated;

  Post({
    this.title,
    this.subtitle,
    this.content,
    this.dateCreated,
    this.id,
  });
  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        subtitle = json['subtitle'],
        dateCreated = json['dateCreated'].toDate();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'subtitle': subtitle,
        'dateCreated': dateCreated,
      };
}
