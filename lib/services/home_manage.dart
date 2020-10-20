import 'package:chat_app/screens/home_tabs.dart';
import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeManage extends ChangeNotifier {
  int currentPage = 0;
  String searchPhoneNumber = '0';

  void queryPhoneNumber(String phone){
    searchPhoneNumber = phone;
    notifyListeners();
  }

  void toggleMessageTab(BuildContext context, MySizes mSizes) {
    notifyListeners();
  }

  void toggleOnlineTab(BuildContext context, MySizes mSizes) {
    notifyListeners();
  }

  void toggleRequestsTab(BuildContext context, MySizes mSizes) {
    notifyListeners();
  }

  Widget currentTab(int tab) {
    if (tab == 0) {
      return MessagesTab();
    } else if (tab == 1) {
      return OnlineTab();
    } else if (tab == 2) {
      return RequestsTab();
    }
    notifyListeners();
  }

  void toggleTabs(int tab){
    currentPage = tab;
    notifyListeners();
  }

}
