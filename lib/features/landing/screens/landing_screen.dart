import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../chat/screens/chat_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Row(
        children: [
          // Sidebar
          _buildMinimalSidebar(),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopNav(),
                  const SizedBox(height: 80),
                  
                  // Welcome Text
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(text: "Hi there, "),
                        TextSpan(
                          text: "Doctor", 
                          style: TextStyle(color: Color(0xFF6C63FF))
                        ),
                      ]
                    ),
                  ),
                  const Text(
                    "What would you like to check today?",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Use our AI assistant to verify clinical guidelines or manage your practice.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 50),
                  
                  // Auth Section
                  _buildAuthSection(context),
                  
                  const SizedBox(height: 60),
                  
                  // Dashboard Grid
                  _buildDashboardGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalSidebar() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.auto_awesome_mosaic, color: Color(0xFF6C63FF), size: 32),
          const SizedBox(height: 60),
          _sidebarIcon(Icons.add, active: false),
          _sidebarIcon(Icons.search),
          _sidebarIcon(Icons.home, active: true),
          _sidebarIcon(Icons.folder_open),
          _sidebarIcon(Icons.history),
          const Spacer(),
          _sidebarIcon(Icons.settings),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData icon, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Icon(
        icon, 
        color: active ? const Color(0xFF6C63FF) : Colors.black45,
        size: 26,
      ),
    );
  }

  Widget _buildTopNav() {
    return Row(
      children: [
        const Text("HealthLink AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const Spacer(),
        _navItem("Dashboard", active: true),
        _navItem("Schedule"),
        _navItem("Patients"),
      ],
    );
  }

  Widget _navItem(String label, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.black : Colors.black45,
          fontWeight: active ? FontWeight.bold : FontWeight.normal
        ),
      ),
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Get Started", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Sign in to save your consultations", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          _authButton(
            icon: FontAwesomeIcons.google, 
            label: "Continue with Google", 
            onPressed: () {},
            color: Colors.white,
            textColor: Colors.black,
            border: true,
          ),
          const SizedBox(width: 16),
          _authButton(
            icon: Icons.email_outlined, 
            label: "Sign up with Email", 
            onPressed: () {},
            color: const Color(0xFF6C63FF),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _authButton({
    required IconData icon, 
    required String label, 
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
    bool border = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon, size: 18, color: textColor),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: border ? BorderSide(color: Colors.black.withOpacity(0.1)) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      children: [
        _buildActionCard(
          context,
          "Start AI Consultation",
          "Analyze symptoms with guidelines",
          Icons.auto_awesome,
          const Color(0xFF6C63FF),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
        ),
        _buildActionCard(
          context,
          "Patient History",
          "View previous consultations",
          Icons.history,
          Colors.orangeAccent,
        ),
        _buildActionCard(
          context,
          "Clinical Guidelines",
          "Browse R1-R14 medical rules",
          Icons.menu_book,
          Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData icon, 
    Color color,
    {VoidCallback? onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
	  child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.black.withOpacity(0.01)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
