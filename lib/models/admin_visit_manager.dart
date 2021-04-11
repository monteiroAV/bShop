import 'dart:async';

import 'package:bhop/models/user.dart';
import 'package:bhop/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminVisitManager extends ChangeNotifier {
  List<User> users = [];
  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;
  void updateVisit(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToVisit();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToVisit() {
    _subscription =
        firestore.collection('visitante').snapshots().listen((snapshot) {
      users = snapshot.documents.map((e) => User.fromDocument(e)).toList();
      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
