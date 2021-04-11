import 'package:bhop/models/page_manager.dart';
import 'package:bhop/models/user_manager.dart';
import 'package:bhop/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        return Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: const DecorationImage(
                    image: AssetImage('assets/logo1.png'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Olá, ${userManager.user?.name ?? 'Visitante'}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (userManager.isLoggedIn) {
                  context.read<PageManager>().setPage(0);
                  userManager.signOut();
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              child: Text(
                userManager.isLoggedIn ? 'Sair' : 'Entre ou Cadastre-se >',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }
}
