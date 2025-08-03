import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:text_extractor_app/components/profile_card.dart';
import 'package:text_extractor_app/providers/theme_provider.dart';
import 'package:text_extractor_app/services/firebase_service.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      _version = info.version;
    });
  }

  void _deleteAllNotes(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete All Notes?"),
        content: const Text(
          "This will delete all your history notes. Are you sure?",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        // Call the Firebase service to delete all notes
        await FirebaseService().deleteAllNotes();
      } catch (e) {
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("All notes deleted.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;

    // Inside build method
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: isDark ? MyColors.lightBlack : MyColors.lightWhite,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile Card
          ProfileCard(user: user),
          const SizedBox(height: 32),
          // Theme Switch
          ListTile(
            leading: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: MyColors.brightBlue,
            ),
            title: const Text("Change Theme"),
            trailing: Switch(
              value: isDark,
              onChanged: (val) => themeProvider.toggleTheme(),
              activeColor: MyColors.brightBlue,
            ),
          ),
          const Divider(height: 32),

          // Version
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text("App Version"),
            trailing: Text(
              _version,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const Divider(height: 32),

          // Delete All Notes
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Delete All History Notes"),
            onTap: () => _deleteAllNotes(context),
          ),
        ],
      ),
    );
  }
}
