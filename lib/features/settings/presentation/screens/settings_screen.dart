import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSection(
            context,
            'Profile',
            [
              _buildListTile(
                context,
                'Edit Profile',
                'Update your personal information',
                Icons.person,
                () => context.push('/profile-setup'),
              ),
              _buildListTile(
                context,
                'Dietary Preferences',
                'Manage your dietary restrictions and preferences',
                Icons.restaurant,
                () => _showDietaryPreferences(context),
              ),
            ],
          ),
          
          // App Settings
          _buildSection(
            context,
            'App Settings',
            [
              _buildListTile(
                context,
                'AI Chat Settings',
                'Configure Gemini API key for AI chat',
                Icons.api,
                () => _showApiSettings(context),
              ),
              _buildListTile(
                context,
                'Notifications',
                'Manage notification preferences',
                Icons.notifications,
                () => _showNotifications(context),
              ),
              _buildListTile(
                context,
                'Theme',
                'Change app appearance',
                Icons.palette,
                () => _showTheme(context),
              ),
              _buildListTile(
                context,
                'Units',
                'Metric or Imperial measurements',
                Icons.straighten,
                () => _showUnits(context),
              ),
            ],
          ),
          
          // Data & Privacy
          _buildSection(
            context,
            'Data & Privacy',
            [
              _buildListTile(
                context,
                'Export Data',
                'Download your meal plans and recipes',
                Icons.download,
                () => _exportData(context),
              ),
              _buildListTile(
                context,
                'Clear Cache',
                'Free up storage space',
                Icons.cleaning_services,
                () => _clearCache(context),
              ),
            ],
          ),
          
          // Support
          _buildSection(
            context,
            'Support',
            [
              _buildListTile(
                context,
                'Help & FAQ',
                'Get help with using the app',
                Icons.help,
                () => _showHelp(context),
              ),
              _buildListTile(
                context,
                'Contact Us',
                'Send feedback or report issues',
                Icons.email,
                () => _contactUs(context),
              ),
              _buildListTile(
                context,
                'About',
                'App version and information',
                Icons.info,
                () => _showAbout(context),
              ),
            ],
          ),
          
          // Account
          _buildSection(
            context,
            'Account',
            [
              _buildListTile(
                context,
                'Logout',
                'Sign out of your account',
                Icons.logout,
                () => _logout(context, ref),
                textColor: AppTheme.errorColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppTheme.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showApiSettings(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gemini API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your Gemini API key to enable AI chat features.\n\nGet your FREE API key at:\ngemini.google.com/apps/apikey',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter your Gemini API key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('gemini_api_key', controller.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('API key saved!')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDietaryPreferences(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dietary Preferences'),
        content: const Text('This would open dietary preferences settings. For MVP, this is a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('This would open notification settings. For MVP, this is a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTheme(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme'),
        content: const Text('This would open theme settings. For MVP, this is a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUnits(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Units'),
        content: const Text('This would open unit settings. For MVP, this is a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export started!')),
    );
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared!')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & FAQ'),
        content: const Text('This would open help documentation. For MVP, this is a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _contactUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Us'),
        content: const Text('This would open contact form. For MVP, this is a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Recipe Meal Planner',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.restaurant_menu,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: [
        const Text('An AI-powered meal planning app for personalized nutrition goals.'),
      ],
    );
  }

  void _logout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/onboarding');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
