import 'package:wry_frontend/models/user_model.dart';
import 'package:wry_frontend/providers/auth_provider.dart';
import 'package:wry_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token!;
      context.read<UserProvider>().fetchUsers(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      body: _buildBody(userProvider),
    );
  }

  Widget _buildBody(UserProvider userProvider) {
    if (userProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.purple),
      );
    }

    if (userProvider.errorMessage != null) {
      return Center(child: Text(userProvider.errorMessage!));
    }

    if (userProvider.users.isEmpty) {
      return const Center(child: Text('No hay usuarios registrados.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userProvider.users.length,
      itemBuilder: (context, index) {
        final user = userProvider.users[index];
        return _UserTile(user: user, userProvider: userProvider);
      },
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final UserProvider userProvider;

  const _UserTile({required this.user, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    final roleLabel = user.role == 'u'
        ? 'Cuidador'
        : user.role == 'p'
            ? 'Paciente'
            : user.role;

    return Slidable(
      key: ValueKey(user.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (_) => _edit(context),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Editar',
          ),
          SlidableAction(
            onPressed: (_) => _delete(context),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Borrar',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.35,
        children: [
          SlidableAction(
            onPressed: (_) => _toggleActive(context),
            backgroundColor: user.isActive ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            icon: user.isActive ? Icons.block : Icons.check,
            label: user.isActive ? 'Desactivar' : 'Activar',
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?'),
          ),
          title: Text(user.name),
          subtitle: Text('${user.email}\nRol: $roleLabel'),
          isThreeLine: true,
          trailing: _ActiveBadge(isActive: user.isActive),
        ),
      ),
    );
  }

  Future<void> _toggleActive(BuildContext context) async {
    final token = context.read<AuthProvider>().token!;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await userProvider.togleActive(user.id, token);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (user.isActive ? 'Usuario desactivado.' : 'Usuario activado.')
              : (userProvider.errorMessage ?? 'No se pudo actualizar el usuario.'),
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Borrar usuario'),
        content: Text('¿Seguro que quieres borrar a ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final token = context.read<AuthProvider>().token!;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await userProvider.deleteUser(user.id, token);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Usuario borrado.' : (userProvider.errorMessage ?? 'No se pudo borrar el usuario.'),
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone ?? '');
    var role = user.role == 'p' ? 'p' : 'u';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Editar usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                ),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: const [
                    DropdownMenuItem(value: 'u', child: Text('Cuidador')),
                    DropdownMenuItem(value: 'p', child: Text('Paciente')),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => role = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !context.mounted) {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      return;
    }

    final token = context.read<AuthProvider>().token!;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await userProvider.updateUser(
      id: user.id,
      token: token,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      role: role,
      phone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Usuario actualizado.' : (userProvider.errorMessage ?? 'No se pudo actualizar el usuario.'),
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final bool isActive;
  const _ActiveBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Activo' : 'Inactivo',
        style: TextStyle(
          color: isActive ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
