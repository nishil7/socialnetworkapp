import 'package:flutter/material.dart';
import 'package:flutter_social/widgets/posts.dart';
import 'package:flutter_social/widgets/cachedimage.dart';

import '../post_screen.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);
  show_Posts(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostScreen(userId: post.ownerId, postId: post.postId)));
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => show_Posts(context),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
