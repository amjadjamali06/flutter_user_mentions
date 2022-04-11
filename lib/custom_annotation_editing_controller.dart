part of flutter_user_mentions;

class CustomAnnotationEditingController extends TextEditingController {
  Map<String, Annotation> _mapping;
  String? _pattern;

  CustomAnnotationEditingController(this._mapping) {
    _pattern = null;
    if(_mapping.keys.isNotEmpty){
      var result = _mapping.keys.map((key) => RegExp.escape(key)).toList();
      result.sort((b,a) => a.toLowerCase().compareTo(b.toLowerCase()));
      _pattern = result.join('|');
    }
  }

  String get markupText {
    final someVal = _mapping.isEmpty
        ? text
        : text.splitMapJoin(
      RegExp('$_pattern'),
      onMatch: (Match match) {

        final mention = _mapping[match[0]!] ??
            _mapping[_mapping.keys.firstWhere((element) {
              final reg = RegExp(element);
              return reg.hasMatch(match[0]!);
            })]!;


        // Default markup format for mentions
        if (!mention.disableMarkup) {
          return mention.markupBuilder != null
              ? mention.markupBuilder!(
              mention.trigger, mention.id!, mention.display!)
              : '${mention.trigger}[__${mention.id}__](__${mention.fullName}__)';
        } else {
          return match[0]!;
        }
      },
      onNonMatch: (String text) {
        return text;
      },
    );

    return someVal;
  }
  Map<String, Annotation> get mapping {
    return _mapping;
  }
  set mapping(Map<String, Annotation> _mapping) {
    this._mapping = _mapping;
    var result = _mapping.keys.map((key) => RegExp.escape(key)).toList();

    result.sort((b,a) => a.toLowerCase().compareTo(b.toLowerCase()));
    _pattern = result.join('|');

  }


  @override
  TextSpan buildTextSpan({BuildContext? context, TextStyle? style, bool? withComposing}) {
    var children = <InlineSpan>[];

    if (_pattern == null || _pattern == '()') {
      children.add(TextSpan(text: text, style: style));
    } else {

      text.splitMapJoin(
        RegExp('$_pattern'),

        onMatch: (Match match) {

          if (_mapping.isNotEmpty) {
            final mention = _mapping[match[0]!] ??
                _mapping[_mapping.keys.firstWhere((element) {
                  final reg = RegExp(element);
                  return reg.hasMatch(match[0]!);
                })]!;
            children.add(
              TextSpan(
                text: match[0]!,
                style: style!.merge(mention.style),
              )
            );
          }
          return '';
        },
        onNonMatch: (String text) {
          children.add(TextSpan(text: text, style: style));
          return '';
        },
      );
    }

    return TextSpan(style: style, children: children);
  }
}
