import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/src/models/models.dart';
import 'package:project/src/presentation/conversation/widgets/chat_text_field.dart';
import 'package:project/src/presentation/conversation/widgets/message_widget.dart';
import 'package:project/src/utils/utils.dart';
import 'package:project/src/presentation/CustomWidgets/CustomSnackBarMessages.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late Conversation conversation;
  final supabase = getIt.get<SupabaseClient>();
  late String id;
  Stream<List<Message>>? stream;

  final controller = TextEditingController();
  Future<String> getTitle() async {
    await Future.delayed(Duration.zero);
    if (conversation.title.isNotEmpty) {
      return conversation.title;
    }

    final otherId = conversation.participants.where((e) => e != id).first;
    if (Profile.cache.containsKey(otherId)) {
      return Profile.cache[otherId]!.display;
    }
    return supabase
        .from('profiles')
        .select()
        .eq('id', otherId)
        .single()
        .then((value) => Profile.cache[otherId] = Profile.fromMap(value))
        .then((value) => value.display);
  }

  void init() async {
    await Future.delayed(Duration.zero);

    if (!mounted) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Conversation) {
      CustomSnackBarMessages.errorMessage(
          context, 'Hubo un error al obtener la conversación');
      return;
    }
    conversation = args;

    id = supabase.auth.currentUser!.id;
    stream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversation.id)
        .order('created_at')
        .map((event) => event.map((e) => Message.fromMap(e)).toList());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getTitle(),
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
              return const Center(
                child: Text('No hay mensajes aún.'),
              );
            }
            return Text(snapshot.data!);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No hay mensajes aún'));
                    }
                    final list = snapshot.data!;
                    if (list.isEmpty) {
                      return const Center(child: Text('No hay mensajes aún'));
                    }
                    return ListView.separated(
                      reverse: true,
                      separatorBuilder: (ctx, idx) => const SizedBox(
                        height: 6,
                      ),
                      itemCount: list.length,
                      itemBuilder: (ctx, idx) {
                        final item = list[idx];
                        return MessageWidget(
                          message: item,
                          isMine: item.createdBy == id,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ChatTextField(
                controller: controller,
                hint: 'ingrese su mensaje',
                onTap: onSend,
                isLoading: isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSend() async {
    if (controller.text.trim().isEmpty) return;
    if (isLoading) return;
    try {
      // // context.showPreloader();
      setState(() {
        isLoading = true;
      });

      await supabase.from('messages').insert({
        'conversation_id': conversation.id,
        'content': controller.text.trim(),
      });
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
    } catch (e) {
      CustomSnackBarMessages.errorMessage(context, e.toString());
      return;
    }
    setState(() {
      isLoading = false;
    });

    controller.clear();
  }
}
