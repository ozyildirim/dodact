import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends BaseState<ResetPasswordPage> {
  AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = getProvider<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
