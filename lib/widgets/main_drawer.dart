import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/providers/auth_provider.dart';
import 'package:shopapp2/screens/orders_screen.dart';
import 'package:shopapp2/screens/product_overview_screen.dart';
import 'package:shopapp2/screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme
            .of(context)
            .primaryColor,
        child: Column(
            children: <Widget>[
        Container(
        margin: EdgeInsets.symmetric(vertical: 100),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.purpleAccent),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme
                    .of(context)
                    .accentColor,
                Theme
                    .of(context)
                    .primaryColor
                    .withOpacity(.9)
              ],
            ),
            borderRadius: BorderRadius.circular(200)),
        child: Icon(
          Icons.group,
          color: Colors.white,
          size: 100,
        ),
      ),
      listTileBuilder(
          title: 'Home',
          iconData: Icons.home,
          handler: () =>
              navigateTo(
                  context: context, route: ProductOverviewScreen.routeName)),
      Divider(color: Colors.deepPurpleAccent, thickness: .3),
      listTileBuilder(
          title: 'Orders',
          iconData: Icons.attach_money,
          handler: () =>
              navigateTo(
                  context: context, route: OrdersScreen.routeName)),
      Divider(color: Colors.deepPurpleAccent, thickness: .3),
      listTileBuilder(
          title: 'User Products',
          iconData: Icons.edit,
          handler: () =>
              navigateTo(
                  context: context, route: UserProductsScreen.routeName)),
      Divider(color: Colors.deepPurpleAccent, thickness: .3),

      listTileBuilder(
          title: 'Logout', iconData: Icons.exit_to_app, handler: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/');
        Provider.of<AuthProvider>(context, listen: false).manuallyLogOut();
      }),
      ],
    ),)
    ,
    );
  }
}

void navigateTo({
  @required BuildContext context,
  @required String route,
}) {
  String routeName = ModalRoute
      .of(context)
      .settings
      .name;
  if (routeName != route) {
    Navigator.of(context).pushReplacementNamed(route);
  } else {
    Navigator.of(context).pop();
  }
}

Widget listTileBuilder({
  @required String title,
  @required IconData iconData,
  @required Function handler,
}) {
  return ListTile(
    title: Text(
      '$title',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    leading: Icon(
      iconData,
      color: Colors.white,
      size: 30,
    ),
    onTap: handler,
  );
}
