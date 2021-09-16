import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiMain(),
    );
  }
}

class ApiMain extends StatefulWidget {
  const ApiMain({Key? key}) : super(key: key);

  @override
  _ApiMainState createState() => _ApiMainState();
}

class _ApiMainState extends State<ApiMain> {

  getUserData() async{
    var response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'posts'));
    var jsonData = jsonDecode(response.body);
    List<Post> posts = [];
    for(var u in jsonData){
      Post post = Post(u["userId"]);
      posts.add(post);
    }
    if(posts.length==10){
      print("Wrong not 10");
    }
    else{
      print("This is correct");
      print(posts.length);
    }
    return posts;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Api Data"),
        ),
        body: Container(
          child: Card(
              child: FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot){
                    if(snapshot.data == null)
                    {
                      return Container(
                        child: Center(
                          child: Text("Loading"),
                        ),
                      );
                    }
                    else {
                      var data = (snapshot.data as List<Post>).toList();
                      return ListView.builder(
                          itemCount: data.length, itemBuilder: (context, i){
                        return ListTile(
                          title: Text(data[i].userId),
                          isThreeLine: true,
                          dense: false,
                          onTap: () {
                            var snackBar = SnackBar(content: Text(data[i].userId));

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            // Scaffold
                            //     .of(context)
                            //     .showSnackBar(SnackBar(content: Text(data.toString())));
                          },
                        );
                      });
                    }
                  }

              )
          ),
        )
    );
  }
}

class Post{
  final String userId;

  Post(this.userId);
}