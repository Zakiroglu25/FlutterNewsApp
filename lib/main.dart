import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailspage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch_data_from_api();
  }

  List data;

  Future<String> fetch_data_from_api() async {
    var jsondata = await http.get(
        "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=6fe88c94f20e44498a038de145a0c8ca");


    var fetchdata = jsonDecode(jsondata.body);
    setState(() {
      data = fetchdata["articles"];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("News App"),
          ),
          body: Padding(
              padding: EdgeInsets.only(top: 35),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                author:data[index]["author"],
                                title:data[index]["title"],
                                description:data[index]["description"],
                                urlToImage:data[index]["urlToImage"],
                                publishedAt:data[index]["publishedAt"],


                              )));
                    },
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                              topRight: Radius.circular(35.0),
                            ),
                            child: Image.network(
                              data[index]["urlToImage"],
                              fit: BoxFit.cover,
                              height: 400.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 350.0, 0.0, 0.0),
                          child: Container(
                            height: 200.0,
                            width: 400.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(35.0),
                              elevation: 10.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    child: Text(
                                      data[index]["title"],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: data == null ? 0 : data.length,
                autoplay: false,
                viewportFraction: 0.8,
                scale: 0.9,
              ))),
    );
  }
}
