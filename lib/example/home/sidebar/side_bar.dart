import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenw=MediaQuery.of(context).size.width ;
    final screenh=MediaQuery.of(context).size.height;
    return Container(
      width: screenw * 0.65,
      child: Drawer(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            children: [
              Container(
                height: screenh* 0.2,

                color: bgDark,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [

                        Card(
                          child: Image.asset('assets/images/Malta icon 1.png'
                          ,width: screenw*0.19,),
                        ),
                    SizedBox(width: 3,),
                    Text(
                          'Malta Weather',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.star_rate),
                title: Text('Rate Us'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text('More Apps'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
