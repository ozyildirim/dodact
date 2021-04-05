import 'package:dodact_v1/config/base/base_state.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends BaseState<SearchPage> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 30.0,
            ),
          ]),
          margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          height: 62,
          child: new TextField(
            controller: _controller,
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const EdgeInsets.only(
                    right: 4.0, top: 2, bottom: 2, left: 2.0),
                child: SizedBox(
                  width: 64.0,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      color: Color(0xffeef1f3),
                      onPressed: () {},
                      child: Center(
                        child: Icon(
                          Icons.search,
                          size: 32,
                          color: Colors.black,
                        ),
                      )),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Ara bakalım ',
              hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600),
              contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
