import 'package:finder/features/auth/view/sign_in.dart';
import 'package:finder/features/home/view_model/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<HomePageVM>(
      create: (_) => HomePageVM(),
      child: Consumer<HomePageVM>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: "Explore Events",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Sign out"),
                    onTap: () {
                      vm.signOut();
                      Navigator.push(context,  MaterialPageRoute(builder: (context){
                        return SignInScreen();
                      }));
                    },
                  ),
                ],
              ),
            ),
            body: Center(child: Text("Home Page")),
          );
        },
      ),
    );
  }
}
