import 'package:alzheimer_frontend/providers/auth_provider.dart';
import 'package:alzheimer_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ManageUserScreen extends StatelessWidget {
  const ManageUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token!;
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      body: ListView.builder(
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];

          return Slidable(
            key: ValueKey(user.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    context.read<UserProvider>().togleActive(
                      user.id,
                      token,
                    );
                  },
                  backgroundColor:
                      user.isActive ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  icon: user.isActive
                      ? Icons.block
                      : Icons.check,
                  label: user.isActive
                      ? "Desactivar"
                      : "Activar",
                ),
              ],
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Icon(
                user.isActive ? Icons.check_circle : Icons.cancel,
                color: user.isActive ? Colors.green : Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}