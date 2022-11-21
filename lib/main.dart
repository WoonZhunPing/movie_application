import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Search App'),
          backgroundColor: Colors.black,
        ),
        body: currentIndex == 0
            ? const Center(
                child: Text(
                  'Welcome to the Movie Search App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Color.fromARGB(255,45, 18, 199)),
                ),
              )
            : currentIndex == 1
                ? const SearchPage()
                : const NotificationPage(),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 20.0,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: 'Search', icon: Icon(Icons.search)),
            BottomNavigationBarItem(
                label: 'Notification', icon: Icon(Icons.notifications)),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  String _value = "";
  String result = "";
  String imageSource = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: textEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Search Movies',
                      contentPadding: EdgeInsets.all(20.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pressButton,
                    child: const Text("Search"),
                  ),
                  Row(
                    children: [
                      if (imageSource == '') ...[
                        const Expanded(
                          child: Image(
                              height: 130.0,
                              //blank image
                              image: NetworkImage(
                                  'https://images-wixmp-530a50041672c69d335ba4cf.wixmp.com/templates/image/5bf41cca049f03cdc7e842db2201172d6cc1a6b173e8db293a3b880ecc5836561616582409012.jpg')),
                        ),
                      ] else ...[
                        Expanded(
                          child:
                              Image(image: NetworkImage(imageSource, scale: 1)),
                        ),
                      ]
                    ],
                  ),
                  Text(result),
                ],
              ),
            )),
      ),
    );
  }

  void _pressButton() {
    setState(() {
      _value = textEditingController.text;
      _searchBar();
    });
  }

  void _searchBar() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Movie Searching"),
        title: const Text("Searching..."));

    progressDialog.show();
    var apiKey = "44a81623";
    var url = Uri.parse('https://www.omdbapi.com/?t=$_value&apikey=$apiKey');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        String title = parsedJson['Title'];
        String releasedDate = parsedJson['Released'];
        String genre = parsedJson['Genre'];
        imageSource = parsedJson['Poster'];
        result = 'Title : $title \nYear : $releasedDate \nGenre : $genre';
      });
    } else {
      setState(() {
        result = "No record";
      });
    }

    progressDialog.dismiss();

    Fluttertoast.showToast(
        msg: "Search Completed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.greenAccent,
        timeInSecForIosWeb: 1,
        fontSize: 20.0);
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Expanded(
                  child: Image(
                      height: 130.0,
                      image: NetworkImage(
                          'https://www.theilluminerdi.com/wp-content/uploads/2022/09/black-adam-heroes.jpg')),
                ),
                Expanded(
                    child: Text(
                        "Black Adam are now available for watched on 21-October-2022",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0))),
             
              ],
            ),
            Row(
              children: const [
                Expanded(
                  child: Image(
                      height: 130.0,
                      image: NetworkImage(
                          'https://flxt.tmsimg.com/assets/p22618843_p_v13_aa.jpg')),
                ),
                Expanded(
                    child: Text(
                        "Guardians of Time are now available for watched on 11-October-2022",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0))),
              ],
            ),
            Row(
              children: const [
                Expanded(
                  child: Image(
                      height: 130.0,
                      image: NetworkImage(
                          'https://m.media-amazon.com/images/M/MV5BZDRmYzQzNjUtNTUxMy00MzBlLWJjYWYtMmY4ZWZjYzYzYTFlXkEyXkFqcGdeQXVyOTg4MDYyNw@@._V1_.jpg')),
                ),
                Expanded(
                    child: Text(
                        "Project Legion are now available for watched on 11-October-2022",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0))),
              ],
            )
          ],
        ),
      )),
    );
  }
}
