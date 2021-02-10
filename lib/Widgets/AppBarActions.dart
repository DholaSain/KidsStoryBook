import 'package:flutter/material.dart';
import 'package:ustaadian/Utils/alertDialog.dart';

import 'LogoImage.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:20.0),
      child: IconButton(
        icon: LogoImage(),
        onPressed: () {
          createAlertDialog(context);
        },
      ),
    );
  }
}