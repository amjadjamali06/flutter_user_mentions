import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_user_mentions/flutter_user_mentions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, child) => Portal(child: child!),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FlutterCustomMentionsState> key = GlobalKey<FlutterCustomMentionsState>();

  String text='';

  List<Map<String, dynamic>> data = [
    {
      'id': '1',
      'display': 'ameerA',
      'full_name': 'Ameer Ali',
      'photo': 'https://media-exp1.licdn.com/dms/image/C5103AQEo4lrx8SL3Xw/profile-displayphoto-shrink_200_200/0/1571245404600?e=1654732800&v=beta&t=dPAaCyxBOuxV3iYTf62zJSZRSowKIFtm2iapC7p3ZDk'
    },
    {
      'id': '2',
      'display': 'amjadjamali06',
      'full_name': 'Amjad Jamali',
      'photo': 'https://avatars.githubusercontent.com/u/84534787'
    },
    {
      'id': '3',
      'display': 'kamran8545',
      'full_name': 'Kamran Khan',
      'photo': 'https://avatars.githubusercontent.com/u/28790321'
    },
    {
      'id': '4',
      'display': 'Ameer_h',
      'full_name': 'Ameer Hamza',
      'photo': 'https://avatars.githubusercontent.com/u/92567854'
    },
    {
      'id': '5',
      'display': 'uzair207',
      'full_name': 'Uzair Hussain',
      'photo': 'https://avatars.githubusercontent.com/u/53579626'
    },
    {
      'id': '6',
      'display': 'afaque97',
      'full_name': 'Afaque Ali',
      'photo': 'https://avatars.githubusercontent.com/u/98380148'
    },
  ];

  Map<String, dynamic> clickedItem = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[

            if(clickedItem.isNotEmpty)
              Text("User Info", style: TextStyle(color: Colors.blue.shade900, fontSize: 20),),

            if(clickedItem.isNotEmpty)
              buildSuggestionItem(clickedItem),

            CustomMentionTextParser(text: text,onMentionedUserClick: (id){
              for(var item in data){
                if(item["id"]==id) {
                  setState(() {
                    clickedItem = item;
                  });
                }
              }
            }),

            ElevatedButton(
              child: const Text('Get Text'),
              onPressed: () {
                setState(() {
                  text = key.currentState!.controller!.markupText;
                });
              },
            ),
            FlutterCustomMentions(
              key: key,
              suggestionPosition: SuggestionPosition.Top,
              maxLines: 5,
              minLines: 1,
              decoration: const InputDecoration(hintText: 'hello'),
              mentions: [
                Mention(
                    trigger: '@',
                    style: const TextStyle(color: Colors.blue),
                    data: data,
                    suggestionBuilder: (item) {
                      return buildSuggestionItem(item);
                    },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget buildSuggestionItem(item) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  item['photo'],
                ),
              ),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item['full_name'], style: const TextStyle(fontWeight: FontWeight.bold),),
                  Text('@${item['display']}'),
                ],
              )
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12),
        ),
        const Divider(thickness: 3,indent: 12,endIndent: 12,),
      ],
    );
  }
}

class User {

  String id;
  String firstName ;
  String lastName;
  String username;
  String photo;

  User({this.id = '', this.firstName= '', this.lastName= '', this.username= '', this.photo= ''});
}