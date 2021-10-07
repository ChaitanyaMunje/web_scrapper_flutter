import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class WebScrap extends StatefulWidget {
  const WebScrap({Key? key}) : super(key: key);

  @override
  _WebScrapState createState() => _WebScrapState();
}

class _WebScrapState extends State<WebScrap> {
  bool isLoading = false;
  late List<String> blogs = [];

  Future<List<String>> extractData() async {
    List<String> titles = [];
    final response =
        await http.Client().get(Uri.parse('https://www.geeksforgeeks.org'));
    if (response.statusCode == 200) {
      var doc = parser.parse(response.body);
      try {
        for (int i = 0; i < 15; i++) {
          if (i == 3|| i==2) {
            continue;
          }
          var resp1 = doc
              .getElementsByClassName('articles-list')[0]
              .children[i]
              .children[0]
              .children[0];

          titles.add(resp1.text.toString());
        }
        return titles;
      } catch (e) {
        return ['error'];
      }
    } else {
      return ['error 2'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geeks for Geeks'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  blogs = await extractData();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('Scrap Data'),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                          itemCount: blogs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Material(
                              elevation: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 10, bottom: 10, right: 5),
                                child: Text(blogs[index].toString()),
                              ),
                            );
                          })),
            ],
          ),
        ),
      ),
    );
  }
}
