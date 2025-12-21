import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mcp_gateway_service.dart';
import '../services/profile_service.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gatewayService = Provider.of<MCPGatewayService>(context);
    final profileService = Provider.of<ProfileService>(context);
    final selectedProfile = profileService.selectedProfile;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chat'),
            if (selectedProfile != null)
              Text(
                '${selectedProfile.icon} ${selectedProfile.name}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              gatewayService.clearMessages();
            },
            tooltip: 'Clear conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedProfile == null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Please select a profile to start chatting'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: gatewayService.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: gatewayService.messages.length,
                    itemBuilder: (context, index) {
                      final message = gatewayService.messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
          ),
          if (gatewayService.isProcessing)
            const LinearProgressIndicator(),
          _buildMessageInput(gatewayService, selectedProfile),
        ],
      ),
    );
  }

  Widget _buildMessageInput(
    MCPGatewayService gatewayService,
    dynamic selectedProfile,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(gatewayService, selectedProfile),
                enabled: selectedProfile != null && !gatewayService.isProcessing,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: selectedProfile != null && !gatewayService.isProcessing
                  ? () => _sendMessage(gatewayService, selectedProfile)
                  : null,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(MCPGatewayService gatewayService, dynamic selectedProfile) {
    if (_messageController.text.trim().isEmpty || selectedProfile == null) {
      return;
    }

    final message = _messageController.text;
    _messageController.clear();
    gatewayService.sendMessage(message, selectedProfile);
    
    // Scroll to bottom after a short delay to allow the message to be added
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }
}
