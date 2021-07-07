import 'package:dodact_v1/ui/feed/widgets/posts_part.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PostsPart(),
      ),
    );
  }
}
