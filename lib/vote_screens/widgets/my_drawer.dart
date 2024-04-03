import 'package:flutter/material.dart';
import 'package:kbops/dashboard_screens/fanproject.dart';
import 'package:kbops/dashboard_screens/website.dart';
import 'package:kbops/drawer.dart';
import 'package:kbops/gallery.dart';
import 'package:kbops/state_management/user_info_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      child: Column(
        children: [
          Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 198, 37, 65),
              ),
              child: userProvider.pointsLoading
                  ? Text('Loading...')
                  : Column(
                      children: [
                        const SizedBox(height: 70),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userProvider
                                  .userInfo?.UserImage ??
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          userProvider.userInfo?.Username ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ],
                    )),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Lastest()));
            },
            child: const ListTile(
              leading: Text(
                'Live Chat',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Gallery()));
            },
            child: const ListTile(
              leading: Text(
                'Image Feeds',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Website()));
            },
            child: const ListTile(
              leading: Text(
                'Blogs & News',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FanProject()));
            },
            child: const ListTile(
              leading: Text('Fan Project Form',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          )
        ],
      ),
    );
  }
}
