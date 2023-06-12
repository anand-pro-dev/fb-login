import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


void main() => runApp(MaterialApp(home: HomePage(),));


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  Map _userObj = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DBestech"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _isLoggedIn
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              imageUrl:_userObj["picture"]["data"]["url"],
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
           // Image.network(_userObj["picture"]["data"]["url"]),
            Text(_userObj["name"]),
            Text(_userObj["email"]),
            TextButton(
                onPressed: () {
                  FacebookAuth.instance.logOut().then((value) {
                    setState(() {
                      _isLoggedIn = false;
                      _userObj = {};
                    });
                  });
                },
                child: Text("Logout"))
          ],
        )
            : Center(
          child: ElevatedButton(
            child: Text("Login with Facebook"),
            onPressed: () async {
              FacebookAuth.instance.login(
                  permissions: ["public_profile", "email"]).then((value) {
                FacebookAuth.instance.getUserData().then((userData) async {
               
                  setState(() {
                    _isLoggedIn = true;
                    _userObj = userData;
                  });
                });
              });
            },
          ),
        ),
      ),
    );
  }
}
