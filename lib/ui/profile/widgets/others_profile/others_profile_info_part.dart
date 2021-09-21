import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OthersProfileInfoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    var user = provider.otherUser;
    if (user == null) {
      return Center(child: spinkit);
    }
    return ListView(
      children: [
        user.nameSurname != null && user.nameSurname.isNotEmpty
            ? ListTile(
                leading: Icon(Icons.person),
                title: Text(user.nameSurname),
              )
            : Container(),
        user.education != null && user.education.isNotEmpty
            ? ListTile(
                leading: Icon(Icons.school),
                title: Text(user.education),
              )
            : Container(),
        ListTile(
          leading: Icon(Icons.category),
          title: Text(user.mainInterest),
        ),
        user.profession != null && user.profession.isNotEmpty
            ? ListTile(
                leading: Icon(Icons.work),
                title: Text(user.profession),
              )
            : Container(),
        user.location != null && user.location.isNotEmpty
            ? ListTile(
                leading: Icon(Icons.location_city),
                title: Text(user.location),
              )
            : Container(),
        Divider(
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 12),
          child: Text("Açıklama", style: TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            user.userDescription,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
