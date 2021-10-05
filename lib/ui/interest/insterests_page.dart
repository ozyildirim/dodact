import 'package:awesome_select/awesome_select.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  bool navigatedFromRegistration;

  InterestsPage({this.navigatedFromRegistration});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends BaseState<InterestsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: !widget.navigatedFromRegistration,
        title: Text('İlgi Alanları'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: choiceWidget(),
      ),
    );
  }

  Widget choiceWidget() {
    List<int> value = [2];
    List<S2Choice<int>> frameworks = [
      S2Choice<int>(value: 1, title: 'Ionic'),
      S2Choice<int>(value: 2, title: 'Flutter'),
      S2Choice<int>(value: 3, title: 'React Native'),
    ];
    return SmartSelect<int>.multiple(
      title: 'Frameworks',
      selectedValue: value,
      choiceItems: frameworks,
      onChange: (state) => setState(() => value = state.value),
    );
  }
}
