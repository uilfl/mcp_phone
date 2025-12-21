import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/profile_service.dart';
import '../models/mcp_profile.dart';
import '../widgets/profile_card.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileService = Provider.of<ProfileService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MCP Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              profileService.refreshProfiles();
            },
            tooltip: 'Refresh profiles',
          ),
        ],
      ),
      body: profileService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileService.profiles.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: profileService.refreshProfiles,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: profileService.profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profileService.profiles[index];
                      final isSelected = profileService.selectedProfile?.id == profile.id;
                      
                      return ProfileCard(
                        profile: profile,
                        isSelected: isSelected,
                        onTap: () {
                          profileService.selectProfile(profile);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected ${profile.name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onToggleStatus: () {
                          profileService.toggleProfileStatus(profile.id);
                        },
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apps_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No profiles available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
