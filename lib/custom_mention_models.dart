part of flutter_mentions;
enum SuggestionPosition { Top, Bottom }

class LengthMap {
  LengthMap({
    required this.start,
    required this.end,
    required this.str,
  });

  String str;
  int start;
  int end;
}

class Mention {
  Mention({
    required this.trigger,
    this.data = const [],
    this.style,
    this.suggestionBuilder,
    this.disableMarkup = false,
    this.markupBuilder,
  });

  final String trigger;
  final List<Map<String, dynamic>> data;
  final TextStyle? style;
  final bool disableMarkup;
  final Widget Function(Map<String, dynamic>)? suggestionBuilder;
  final String Function(String trigger, String mention, String value)?
      markupBuilder;
}

class Annotation {
  Annotation({
    required this.trigger,
    this.style,
    this.id,
    this.display,
    this.fullName,
    this.disableMarkup = false,
    this.markupBuilder,
  });

  TextStyle? style;
  String? id;
  String? display;
  String? fullName;
  String trigger;
  bool disableMarkup;

  final String Function(String trigger, String mention, String value)? markupBuilder;
}


