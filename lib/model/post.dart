class Post {
  String? id;
  String? title;
  String? content;
  String? subtitle;
  String? imageUrl;
  //DateTime? dateCreated;

  Post({
    this.title,
    this.subtitle,
    this.content,
    //this.dateCreated,
    this.id,
    this.imageUrl,
  });

  //String toStrint() => id! + "/" + title! + "/" + content! + '/' + subtitle!;

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        imageUrl = json['imageUrl'],
        subtitle = json['subtitle'];
  // dateCreated = json['dateCreated'].toDate();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'subtitle': subtitle,
        'imageUrl': imageUrl,
        // 'dateCreated': dateCreated,
      };
}
