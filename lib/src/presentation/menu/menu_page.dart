import 'package:flutter/material.dart';
import 'package:project/src/models/settingOption/SettingOption.dart';
import 'package:project/src/presentation/CustomWidgets/CustomPreloader.dart';
import 'package:project/src/presentation/CustomWidgets/CustomSnackBarMessages.dart';
import 'package:project/src/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  TextEditingController nameController = TextEditingController();

  final supabase = getIt.get<SupabaseClient>();

  Future<String> getUserName() async {
    final currentUserId = supabase.auth.currentUser?.id;
    String userName = "";
    try {
      final response = await supabase
          .from('profiles')
          .select('first_name, last_name')
          .eq('id', currentUserId);
      userName += (response[0]['first_name']) + " ";
      userName += (response[0]['last_name']);
    } catch (e) {
      // ignore: use_build_context_synchronously
      CustomSnackBarMessages.errorMessage(context, e.toString());
    }
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getUserName(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('It Failed, restart the app'));
          }

          final String? actualName = snapshot.data;

          final List<SettingOption> options = [
            SettingOption(
                title: 'Edit Profile',
                subtitle: 'Change your name and last name.',
                icon: Icons.manage_accounts,
                onTap: () => onEditProfile(actualName)),
            SettingOption(
              title: 'Logout',
              subtitle: 'Close your session.',
              icon: Icons.logout,
              onTap: onLogOut,
            )
          ];

          return Scaffold(
              appBar: AppBar(
                title: const Text('Menu'),
              ),
              body: Container(
                alignment: Alignment.center,
                child: Column(children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Greetings $actualName',
                            style: const TextStyle(fontSize: 36),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SettingItem(
                                  options[index].title,
                                  options[index].subtitle,
                                  options[index].icon,
                                  options[index].onTap);
                            })
                      ]),
                    ),
                  ),
                ]),
              ));
        });
  }

  onEditProfile(String? oldName) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/editProfile', (route) => false);
  }

  void onLogOut() async {
    final CustomPreloader preloader = CustomPreloader(context);
    try {
      preloader.showPreloader();
      await supabase.auth.signOut();
      if (!mounted) return;
      await preloader.hidePreloader();
    } on Exception catch (e) {
      // ignore: use_build_context_synchronously
      CustomSnackBarMessages.errorMessage(context, e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  // ignore: non_constant_identifier_names
  Widget SettingItem(
      String title, String subtitle, IconData icon, VoidCallback? onTap) {
    return ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Text(subtitle),
        leading: CircleAvatar(
          child: Icon(icon),
        ));
  }
}
