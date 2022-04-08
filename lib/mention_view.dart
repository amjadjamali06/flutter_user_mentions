part of flutter_mentions;

class FlutterCustomMentions extends StatefulWidget {
  const FlutterCustomMentions({
    required this.mentions,
    Key? key,
    this.defaultText,
    this.suggestionPosition = SuggestionPosition.Bottom,
    this.suggestionListHeight = 300.0,
    this.onMarkupChanged,
    this.onMentionAdd,
    this.onSearchChanged,
    this.leading = const [],
    this.trailing = const [],
    this.suggestionListDecoration,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.readOnly = false,
    this.showCursor,
    this.maxLength,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.onTap,
    this.buildCounter,
    this.scrollPhysics,
    this.scrollController,
    this.autofillHints,
    this.appendSpaceOnAdd = true,
    this.hideSuggestionList = false,
    this.onSuggestionVisibleChanged,
  }) : super(key: key);

  final bool hideSuggestionList;
  final String? defaultText;
  final Function(bool)? onSuggestionVisibleChanged;
  final List<Mention> mentions;
  final List<Widget> leading;
  final List<Widget> trailing;
  final SuggestionPosition suggestionPosition;
  final Function(Map<String, dynamic>)? onMentionAdd;
  final double suggestionListHeight;
  final ValueChanged<String>? onMarkupChanged;
  final void Function(String trigger, String value)? onSearchChanged;
  final BoxDecoration? suggestionListDecoration;
  final FocusNode? focusNode;
  final bool appendSpaceOnAdd;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final int maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  static const int noMaxLength = -1;
  final int? maxLength;
  final MaxLengthEnforcement maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool? enabled;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  bool get selectionEnabled => enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;

  @override
  FlutterCustomMentionsState createState() => FlutterCustomMentionsState();
}

class FlutterCustomMentionsState extends State<FlutterCustomMentions> {
  CustomAnnotationEditingController? controller;
  ValueNotifier<bool> showSuggestions = ValueNotifier(false);
  LengthMap? _selectedMention;
  String _pattern = '';
  int dataId=0;

  Map<String, Annotation> mapToAnotation() {
    final data = <String, Annotation>{};

    // Loop over all the mention items and generate a suggestions matching list
    for (var element in widget.mentions) {

      for (var e in element.data) {

                data["${element.trigger}${e['display']}"] =
                Annotation(
                  style: element.style,
                  id: e['id'],
                  display: e['display'],
                  fullName: e['full_name'],
                  trigger: element.trigger,
                  disableMarkup: element.disableMarkup,
                  markupBuilder: element.markupBuilder,
                );}
    }
    return data;
  }
  void addMention(Map<String, dynamic> value, [Mention? list]) {
    final selectedMention = _selectedMention!;
    setState(() {
      _selectedMention = null;
    });

    final _list = widget.mentions.firstWhere((element) => selectedMention.str.contains(element.trigger));
    // find the text by range and replace with the new value.
    controller!.text = controller!.value.text.replaceRange(
      selectedMention.start,
      selectedMention.end,
      "${_list.trigger}${value['display']}${widget.appendSpaceOnAdd?' ':''}",
    );

    if (widget.onMentionAdd != null) widget.onMentionAdd!(value);

    // Move the cursor to next position after the new mentioned item.
    var nextCursorPosition =
        selectedMention.start +1+ value['display']?.length  as int? ?? 0;
    if (widget.appendSpaceOnAdd) nextCursorPosition++;




    controller!.selection =
        TextSelection.fromPosition(TextPosition(offset: nextCursorPosition));


  }


  void suggestionListener() {
    final cursorPos = controller!.selection.baseOffset;

    if (cursorPos >= 0) {
      var _pos = 0;

      final lengthMap = <LengthMap>[];

      // split on each word and generate a list with start & end position of each word.
      controller!.value.text.split(RegExp(r'(\s)')).forEach((element) {
        lengthMap.add(LengthMap(str: element, start: _pos, end: _pos + element.length));
        _pos = _pos + element.length + 1;
      });


      final val = lengthMap.indexWhere((element) {
        _pattern = widget.mentions.map((e) => e.trigger).join('|');

        return element.end == cursorPos &&
            element.str.toLowerCase().contains(RegExp(_pattern));
      });


      showSuggestions.value = val != -1;

      if (widget.onSuggestionVisibleChanged != null) {
        widget.onSuggestionVisibleChanged!(val != -1);
      }

      setState(() {
        _selectedMention = val == -1 ? null : lengthMap[val];
      });
    }
  }
  void inputListeners() {

    if (widget.onChanged != null) {
      widget.onChanged!(controller!.text);
    }

    if (widget.onMarkupChanged != null) {
      widget.onMarkupChanged!(controller!.markupText);
    }

    if (widget.onSearchChanged != null && _selectedMention?.str != null) {
      final str = _selectedMention!.str.toLowerCase();

      widget.onSearchChanged!(str[0], str.substring(1));
    }
  }
  @override
  void initState() {
    final data = mapToAnotation();
    controller = CustomAnnotationEditingController(data);

    if (widget.defaultText != null) {
      controller!.text = widget.defaultText!;
    }

    _pattern = widget.mentions.map((e) => e.trigger).join('|');
    controller!.addListener(suggestionListener);
    controller!.addListener(inputListeners);
    super.initState();
  }
  @override
  void dispose() {
    controller!.removeListener(suggestionListener);
    controller!.removeListener(inputListeners);

    super.dispose();
  }
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    controller!.mapping = mapToAnotation();
  }
  @override
  Widget build(BuildContext context) {
    // Filter the list based on the selection
    final list = _selectedMention != null
        ? widget.mentions.firstWhere(
            (element) => _selectedMention!.str.contains(element.trigger))
        : widget.mentions[0];

    return PortalEntry(
      portalAnchor: Alignment.bottomCenter,
      childAnchor: Alignment.topCenter,
      portal: ValueListenableBuilder(
        valueListenable: showSuggestions,
        builder: (BuildContext context, bool show, Widget? child) {
          return show && !widget.hideSuggestionList
              ? OptionList(
            suggestionListHeight: widget.suggestionListHeight,
            suggestionBuilder: list.suggestionBuilder,
            suggestionListDecoration: widget.suggestionListDecoration,
            data: list.data.where((element) {
              final ele = element['display'].toLowerCase();
              final str = _selectedMention!.str.toLowerCase().replaceAll(RegExp(_pattern), '');
              return ele == str ? true : ele.contains(str);
            }).toList(),

            onTap: (value) {
              addMention(value,list);
              showSuggestions.value = false;
            },
          )
              : Container();
        },
      ),
      child: Row(
        children: [
          ...widget.leading,
          Expanded(
            child: TextField(
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              keyboardAppearance: widget.keyboardAppearance,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              style: widget.style,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              readOnly: widget.readOnly,
              showCursor: widget.showCursor,
              autofocus: widget.autofocus,
              autocorrect: widget.autocorrect,
              maxLengthEnforcement: widget.maxLengthEnforcement,
              cursorColor: widget.cursorColor,
              cursorRadius: widget.cursorRadius,
              cursorWidth: widget.cursorWidth,
              buildCounter: widget.buildCounter,
              autofillHints: widget.autofillHints,
              decoration: widget.decoration,
              expands: widget.expands,
              onEditingComplete: widget.onEditingComplete,
              onTap: widget.onTap,
              onSubmitted: widget.onSubmitted,
              enabled: widget.enabled,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              enableSuggestions: widget.enableSuggestions,
              scrollController: widget.scrollController,
              scrollPadding: widget.scrollPadding,
              scrollPhysics: widget.scrollPhysics,
              controller: controller,
            ),
          ),
          ...widget.trailing,
        ],
      ),
    );
  }
}
