class TodoItem {
  final String title;

  TodoItem(this.title);

  TodoItem.fromJson(Map json) : title = json['title'];

  Map toJson() => {
    'title': title
  };

}