part of flutter_user_mentions;

/*Created By: Amjad Jamali on 21-Mar-2022*/

class CustomMentionTextParser extends StatelessWidget {

  final String text;
  final Function(String)? onMentionedUserClick;
  final Color textColor;
  final double? fontSize;
  final Color? mentionedTextColor;

  CustomMentionTextParser({
    required this.text,
    this.onMentionedUserClick,
    this.fontSize,
    this.textColor = Colors.black,
    this.mentionedTextColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: text.split('@[__').map((users) {
          List<String> words  = users.split("__)");
          if(words.isNotEmpty && words.length>1){
            List<String> user = words.first.split("__](__");
            if(user.length>1) {
              return TextSpan(
                text: user.last,
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (onMentionedUserClick != null) {
                      onMentionedUserClick!(user.first);
                    }
                  },
                children: [
                  for(int i = 1 ;i<words.length;i++)
                    TextSpan(
                      text: i>1?"__)${words[i]}":words[i],
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              );
            }else{
              return TextSpan(
                text: '$words',
                style: TextStyle(fontSize: fontSize, color: Colors.black),
              );
            }
          }

          return TextSpan(
            text: users,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          );
        }).toList(),
      ),
    );
  }
}

