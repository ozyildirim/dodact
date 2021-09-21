import 'package:dodact_v1/config/base/base_state.dart';
import 'package:flutter/material.dart';

class UserProfileInfoTab extends StatefulWidget {
  @override
  State<UserProfileInfoTab> createState() => _UserProfileInfoTabState();
}

class _UserProfileInfoTabState extends BaseState<UserProfileInfoTab> {
  @override
  Widget build(BuildContext context) {
    var user = authProvider.currentUser;
    var size = MediaQuery.of(context).size;
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
