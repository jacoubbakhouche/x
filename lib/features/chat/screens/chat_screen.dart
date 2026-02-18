import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      backgroundColor: const Color(0xFFF5F6F8),
      body: Row(
        children: [
          // Left Workspace Sidebar
          _buildSidebar(context),
          
          // Main Chat Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40, offset: const Offset(0, 20))
                ],
              ),
              child: Column(
                children: [
                  // App Bar / Header
                  _buildHeader(context),
                  
                  // Messages or Empty State
                  Expanded(
                    child: messages.isEmpty 
                      ? _buildEmptyState() 
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(32),
                          itemCount: messages.length + (chatState.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                             if (index == messages.length) {
                               return const Padding(
                                 padding: EdgeInsets.all(16.0),
                                 child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                               );
                             }
                             return _buildMessageBubble(messages[index]);
                          },
                        ),
                  ),

                  // Input Area
                  _buildInputArea(ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome_mosaic, color: Color(0xFF6C63FF), size: 32),
          const SizedBox(height: 48),
          _sidebarIcon(Icons.add_circle_outline),
          _sidebarIcon(Icons.search),
          _sidebarIcon(Icons.home, active: true, onTap: () => Navigator.pop(context)),
          _sidebarIcon(Icons.folder_outlined),
          _sidebarIcon(Icons.history),
          const Spacer(),
          _sidebarIcon(Icons.settings_outlined),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF6C63FF),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData icon, {bool active = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: onTap,
        child: Icon(icon, color: active ? const Color(0xFF6C63FF) : Colors.black38, size: 28),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          const Flexible(
            child: Text(
              "AI Consultation", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black45),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(text: "Hi there, "),
                    TextSpan(text: "Doctor\n", style: TextStyle(color: Color(0xFF6C63FF))),
                    TextSpan(text: "What would like to know?"),
                  ]
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Use one of the most common prompts below or use your own to begin",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black38, fontSize: 14),
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _suggestionCard("Check antibiotic dosage for pediatric patient", Icons.person_outline),
                  _suggestionCard("Analyze symptoms for potential abscess", Icons.medical_services_outlined),
                  _suggestionCard("Pulpite guidelines for antibiotics", Icons.question_answer_outlined),
                  _suggestionCard("Alternatives for Penicillin allergy", Icons.tune_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestionCard(String text, IconData icon) {
    return InkWell(
      onTap: () => ref.read(chatControllerProvider.notifier).sendMessage(text),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 220,
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9FB),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.01)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                text, 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(icon, color: Colors.black38, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.only(bottom: 24),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF6C63FF) : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: "Ask whatever you want....",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black26),
              ),
              onSubmitted: (val) => _sendMessage(ref),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _inputAction(Icons.add_circle_outline, "Add Attachment"),
                const SizedBox(width: 20),
                _inputAction(Icons.image_outlined, "Use Image"),
                const Spacer(),
                const Text("0/1000", style: TextStyle(color: Colors.black26, fontSize: 12)),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _sendMessage(ref),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _inputAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black38),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _sendMessage(WidgetRef ref) {
    if (_textController.text.trim().isEmpty) return;
    ref.read(chatControllerProvider.notifier).sendMessage(_textController.text);
    _textController.clear();
  }
}

