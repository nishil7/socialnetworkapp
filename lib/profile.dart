import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/widgets/header.dart';
import 'package:flutter_social/widgets/post_tile.dart';
import 'package:flutter_social/widgets/posts.dart';
import 'package:flutter_social/widgets/progress.dart';
import 'package:flutter_svg/svg.dart';

import 'edit_profile.dart';
import 'homescreen.dart';
import 'model/user.dart';


class Profile extends StatefulWidget {
  final String? profile_Id;

  Profile({required this.profile_Id});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String? currentUserId = current_User?.id;
  bool post_Orientation = true;
  bool isLoading = false;
  int post_Count = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(widget.profile_Id)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      post_Count = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }
  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditProfile(currentUserId: currentUserId)));

  }

  Container buildButton({required String text, required Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: ElevatedButton(
        onPressed:()=>function(),
        child: Container(
          width: 220.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUserId == widget.profile_Id;
    if (isProfileOwner) {
      return buildButton(text: "Edit Profile", function: editProfile);
    }
  }

  build_Profile_Header() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profile_Id).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circular_Progress();
        }
        Users user = Users.fromDocument(snapshot.data!);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn("posts", post_Count),
                            buildCountColumn("followers", 0),
                            buildCountColumn("following", 0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  user.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  user.bio,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  setPost_Orientation(bool post_Orientation) {
    setState(() {
      this.post_Orientation = post_Orientation;
    });
  }

  build_TogglePost_Orientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPost_Orientation(true),
          icon: Icon(Icons.grid_on),
          color: post_Orientation == true
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPost_Orientation(false),
          icon: Icon(Icons.list),
          color: post_Orientation == false
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }
  build_Profile_Posts() {
    if (isLoading) {
      return circular_Progress();
    }
    else if (posts.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('images/no_content.svg', height: 260.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Nothing to Show",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    else if(post_Orientation == true){
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child: PostTile(post)));
      });
      return GridView.count(
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisCount: 3,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    }
    else{
      return Column(
        children: posts,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: "Profile"),
      body: ListView(
        children: <Widget>[
          build_Profile_Header(),
          Divider(),
          build_TogglePost_Orientation(),
          Divider(
            height: 0.0,
          ),
      build_Profile_Posts()
        ],
      ),
    );
  }
}



