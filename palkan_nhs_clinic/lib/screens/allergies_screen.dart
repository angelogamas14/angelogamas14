import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AllergiesScreen extends StatefulWidget {
  const AllergiesScreen({super.key});

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  final List<String> _common = const ['Seafoods', 'Eggs', 'Nuts', 'Milk', 'Soy', 'Wheat'];
  final TextEditingController _otherController = TextEditingController();
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _selected.addAll(user.allergies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Allergies')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select common allergies:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _common
                  .map((a) => FilterChip(
                        label: Text(a),
                        selected: _selected.contains(a),
                        onSelected: (s) => setState(() => s ? _selected.add(a) : _selected.remove(a)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Add more:'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _otherController,
                    decoration: const InputDecoration(hintText: 'e.g., Pollen'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final val = _otherController.text.trim();
                    if (val.isEmpty) return;
                    setState(() => _selected.add(val));
                    _otherController.clear();
                  },
                  child: const Text('Add'),
                )
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: () async {
                final auth = context.read<AuthProvider>();
                final user = auth.currentUser!;
                final updated = user.copyWith(allergies: _selected.toList());
                await AuthService().updateUser(updated);
                auth.setCurrentUser(updated);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Allergies saved')),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
