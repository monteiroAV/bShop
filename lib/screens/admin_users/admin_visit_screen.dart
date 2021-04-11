import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:bhop/models/admin_visit_manager.dart';
import 'package:bhop/screens/base/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminVisitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text('Visitantes'),
          centerTitle: true,
        ),
        body: Consumer<AdminVisitManager>(
          builder: (_, adminUsersManager, __) {
            return AlphabetListScrollView(
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    adminUsersManager.users[index].name,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    adminUsersManager.users[index].email,
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: Text(
                    adminUsersManager.users[index].phone,
                    style: TextStyle(color: Colors.black87),
                  ),
                );
              },
              highlightTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              indexedHeight: (index) => 80,
              strList: adminUsersManager.names,
              showPreview: true,
            );
          },
        ));
  }
}

