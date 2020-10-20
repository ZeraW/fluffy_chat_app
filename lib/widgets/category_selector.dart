import 'package:chat_app/services/home_manage.dart';
import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class CategorySelector extends StatelessWidget {
  int selectedIndex = 0;
  final List<String> categories = ['Messages', 'Online', 'Requests'];

  @override
  Widget build(BuildContext context) {
    MySizes mSizes = MySizes(context);

    return Container(
      height: mSizes.getDesirableHeight(12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Consumer<HomeManage>(builder: (context, home, child) {
              return GestureDetector(
                onTap: () {
                  if(home.currentPage!=index) //cancel the onclick for the selected page
                  home.toggleTabs(index);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: mSizes.getDesirableHeight(4),
                  ),
                  child:  Text(
                        categories[index],
                        style: TextStyle(
                          color: index == home.currentPage ? Colors.white : Colors.white60,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                ),
              );
            }
          );
        },
      ),
    );
  }
}