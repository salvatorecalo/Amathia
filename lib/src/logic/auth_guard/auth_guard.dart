import 'package:amathia/src/logic/user_logic/user_provider.dart';
import 'package:amathia/src/screens/home_page/home_page.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends ConsumerWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final session = ref.watch(authSessionProvider);
    if (session == null){
      return const LoginPage();
    } else {
      return HomePage();
    }
  }
}