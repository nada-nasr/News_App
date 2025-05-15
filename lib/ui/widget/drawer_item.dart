import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';

class DrawerItem extends StatelessWidget {
  String image;
  String text;
   DrawerItem({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(
          horizontal: width*0.02,
          vertical: height*0.02
      ),
      child: Row(
        children: [
          Image.asset(image),
          SizedBox(width: width*0.01),
          Text(text,
              style: AppStyles.bold20white)
        ],
      ),
    );
  }
}
