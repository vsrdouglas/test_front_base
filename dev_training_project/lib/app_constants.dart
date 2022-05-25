// ignore_for_file: prefer_typing_uninitialized_variables, library_prefixes

import 'dart:async';

import 'flavors.dart' as Flav;

late StreamController refreshController1;
late StreamController refreshController2;
late StreamController refreshController3;

updateStream() {
  refreshController1 = StreamController();
  refreshController2 = StreamController();
  refreshController3 = StreamController();
}

String reportUrl = Flav.F.url[0];

String usersUrl = Flav.F.url[1];

String projectsUrl = Flav.F.url[2];

String loginUrl = Flav.F.url[3];

String dadosUser = Flav.F.url[4];

String forgotUrl = Flav.F.url[5];

String resetToken = Flav.F.url[6];

String reset = Flav.F.url[7];

String allUsers = Flav.F.url[8];

String historyUser = Flav.F.url[9];

String equipments = Flav.F.url[10];

String equipmentsAvailable = Flav.F.url[11];

String defaultImage =
    'https://firebasestorage.googleapis.com/v0/b/project-manager-dead4.appspot.com/o/user.png?alt=media&token=444f77c3-adc5-478c-bfcd-3ae0ca47c7a7';

String defaultImageThumb =
    'https://firebasestorage.googleapis.com/v0/b/project-manager-dead4.appspot.com/o/Untitled%20design%20(1).png?alt=media&token=ff31564d-2666-4e52-9415-94c499a20581';

var token;

var tokenKey;

class Auth {
  update(t) {
    token = t;
  }

  getTokenKey(t) {
    tokenKey = t;
  }
}
// var token = Auth().get();
