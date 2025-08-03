class Note {
  final String title;
  final String text;
  final String date;

  Note({
    required this.title,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'text': text,
        'date': date,
      };
}
