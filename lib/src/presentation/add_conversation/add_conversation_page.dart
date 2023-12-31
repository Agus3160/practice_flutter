import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/src/presentation/add_conversation/widgets/add_title_overlay.dart';

import '../../models/models.dart';
import '../../utils/utils.dart';
import 'package:project/src/presentation/CustomWidgets/CustomPreloader.dart';
import 'package:project/src/presentation/CustomWidgets/CustomSnackBarMessages.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<Profile>> future;
  final participants = <String>{};
  final supabase = getIt.get<SupabaseClient>();
  late String id;
  @override
  void initState() {
    id = supabase.auth.currentUser!.id;

    future = supabase
        .from('profiles')
        .select<List<Map<String, dynamic>>>('*')
        .not('id', 'eq', id)
        .then((value) => value.map((e) => Profile.fromMap(e)).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        actions: [
          CupertinoButton(
            onPressed: onSave,
            child: const Icon(Icons.done),
          )
        ],
      ),
      body: FutureBuilder(
        future: future,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('There is no conversation'));
          }
          final list = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (ctx, idx) => const SizedBox(
              height: 16,
            ),
            itemCount: list.length,
            itemBuilder: (ctx, idx) {
              final item = list[idx];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    item.firstName.substring(0, 2),
                  ),
                ),
                title: Text(item.display),
                onTap: () => onSelected(item.id),
                trailing: Checkbox.adaptive(
                  value: participants.contains(item.id),
                  onChanged: (v) => onSelected(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onSelected(String id) {
    if (participants.contains(id)) {
      setState(() {
        participants.removeWhere((e) => id == e);
      });
    } else {
      setState(() {
        participants.add(id);
      });
    }
  }

  void onSave() async {
    final CustomPreloader preloader = CustomPreloader(context);

    if (participants.isEmpty) {
      CustomSnackBarMessages.errorMessage(
          context, 'You have to select a participant');
      return;
    }

    late Conversation conversation;
    participants.add(id);

    if (participants.length > 2) {
      final result = await showCupertinoModalPopup(
        context: context,
        builder: (ctx) => const AddTitleOverlay(),
      ) as String?;
      if (result == null) return;
      conversation = Conversation.create(
        participants: participants.toList(),
        title: result,
      );
    } else {
      conversation = Conversation.create(
        participants: participants.toList(),
      );
      try {
        if (!mounted) return;
        preloader.showPreloader();
        final or =
            'participants.cs.{${participants.toList().reversed.join(',')}}';
        final c = await supabase
            .from('conversations')
            .select<List<Map<String, dynamic>>>()
            .or(or)
            .then(
              (value) => value
                  .map((e) => Conversation.fromMap(e))
                  .where((a) => a.participants.length == 2),
            );

        if (!mounted) return;
        await preloader.hidePreloader();
        // log.d(c);
        if (c.length > 1) {
          if (!mounted) return;
          CustomSnackBarMessages.errorMessage(context, 'Something went wrong');
          return;
        }
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(
          '/conversation',
          arguments: c.first,
        );
        return;
      } catch (e) {
        log.d(e);
      }
    }
    try {
      if (!mounted) return;
      preloader.showPreloader();
      final c = await supabase
          .from('conversations')
          .upsert(conversation.toMap())
          .select('*')
          .single()
          .then((value) => Conversation.fromMap(value));
      if (!mounted) return;
      await preloader.hidePreloader();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        '/conversation',
        arguments: c,
      );
    } on Exception catch (e) {
      if (!mounted) return;
      await preloader.hidePreloader();
      if (!mounted) return;
      CustomSnackBarMessages.errorMessage(context, e.toString());
      return;
    }
  }
}
