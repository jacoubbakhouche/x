import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../logic/chat_controller.dart';
import '../models/chat_message.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider);
    final messages = chatState.messages;

    ref.listen(chatControllerProvider, (previous, next) {
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2E2A4F), Color(0xFF1B1B2F)],
              ),
            ),
          ),
          
          SafeArea(
            child: Row(
              children: [
                // Sidebar (Simulated for Web aesthetics)
                if (MediaQuery.of(context).size.width > 800)
                  _buildSidebar(context),

                // Main Chat Area
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            const Text(
                              'AI Consultation',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Go back to landing
                              }, 
                              icon: const CircleAvatar(
                                backgroundColor: Color(0xFF6C63FF),
                                child: Icon(Icons.home, color: Colors.white),
                              )
                            )
                          ],
                        ),
                      ),
                      
                      // Messages
                      Expanded(
                        child: messages.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                itemCount: messages.length + (chatState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == messages.length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                                      ),
                                    );
                                  }
                                  return _buildMessageBubble(messages[index]);
                                },
                              ),
                      ),
                      _buildInputArea(ref),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.black.withOpacity(0.2),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("History", style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 20),
          _sidebarItem("Patient consultation #1"),
          _sidebarItem("Antibiotic rules"),
        ],
      ),
    );
  }

  Widget _sidebarItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: const TextStyle(color: Colors.white70)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _suggestionCard("Check antibiotic dosage for pediatric patient"),
          const SizedBox(height: 16),
          _suggestionCard("Analyze symptoms for potential abscess"),
        ],
      ),
    );
  }

  Widget _suggestionCard(String text) {
    return GestureDetector(
      onTap: () {
        ref.read(chatControllerProvider.notifier).sendMessage(text);
      },
      child: GlassmorphicContainer(
        width: 300,
        height: 80,
        borderRadius: 16,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
        borderGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.2)]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
               Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
               const Icon(Icons.arrow_forward, color: Colors.white54)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF6C63FF) : const Color(0xFF2D2F45),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Text(
          message.content,
          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
        ),
      ),
    );
  }

  Widget _buildInputArea(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 40,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.01)]),
        borderGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                    filled: false,
                  ),
                  onSubmitted: (val) => _sendMessage(ref),
                ),
              ),
              IconButton(
                onPressed: () => _sendMessage(ref),
                icon: const CircleAvatar(
                  backgroundColor: Color(0xFF6C63FF),
                  child: Icon(Icons.send_rounded, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(WidgetRef ref) {
     final text = _textController.text;
      if (text.isNotEmpty) {
        ref.read(chatControllerProvider.notifier).sendMessage(text);
        _textController.clear();
      }
  }
}

