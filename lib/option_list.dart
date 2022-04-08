part of flutter_user_mentions;

class OptionList extends StatelessWidget {

  final Widget Function(Map<String, dynamic>)? suggestionBuilder;
  final List<Map<String, dynamic>> data;
  final Function(Map<String, dynamic>) onTap;
  final double suggestionListHeight;
  final BoxDecoration? suggestionListDecoration;

  OptionList({
    required this.data,
    required this.onTap,
    required this.suggestionListHeight,
    this.suggestionBuilder,
    this.suggestionListDecoration,
  });


  @override
  Widget build(BuildContext context) {
    return data.isNotEmpty
        ? Container(
            decoration:
                suggestionListDecoration ?? const BoxDecoration(color: Colors.white),
            constraints: BoxConstraints(
              maxHeight: suggestionListHeight,
              minHeight: 0,
            ),
            child: ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onTap(data[index]);
                  },
                  child: suggestionBuilder != null
                      ? suggestionBuilder!(data[index])
                      : Container(
                          color: Colors.blue,
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            data[index].toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                );
              },
            ),
          )
        : Container();
  }
}
