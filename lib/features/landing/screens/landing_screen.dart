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
                  _buildTopNav(context),
                  const SizedBox(height: 60),
                  
                  // Welcome Text + Doctor Image (Responsive)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmall = constraints.maxWidth < 900;
                      return Wrap(
                        direction: isSmall ? Axis.vertical : Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 40,
                        runSpacing: 40,
                        children: [
                          SizedBox(
                            width: isSmall ? constraints.maxWidth : constraints.maxWidth * 0.55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: isSmall ? 40 : 56, 
                                      fontWeight: FontWeight.bold, 
                                      color: Colors.black
                                    ),
                                    children: [
                                      const TextSpan(text: "Hi there, "),
                                      const TextSpan(
                                        text: "Doctor", 
                                        style: TextStyle(color: Color(0xFF6C63FF))
                                      ),
                                    ]
                                  ),
                                ),
                                Text(
                                  "What would you like to check today?",
                                  style: TextStyle(
                                    fontSize: isSmall ? 40 : 56, 
                                    fontWeight: FontWeight.bold, 
                                    color: const Color(0xFF6C63FF), 
                                    height: 1.1
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "Use our AI assistant to verify clinical guidelines, check dosages,\nor manage your medical practice with precision.",
                                  style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
                                ),
                                const SizedBox(height: 40),
                                _buildAuthSection(context),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: isSmall ? constraints.maxWidth : constraints.maxWidth * 0.35,
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: isSmall ? 250 : 350,
                                    height: isSmall ? 250 : 350,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [const Color(0xFF6C63FF).withOpacity(0.1), Colors.white],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  ),
                                  Image.network(
                                    "https://cdni.iconscout.com/illustration/premium/thumb/male-doctor-illustration-download-in-svg-png-gif-file-formats--medical-healthcare-services-pack-people-illustrations-3306917.png?f=webp",
                                    height: isSmall ? 300 : 450,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 200, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 80),
                  
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
          _sidebarIcon(Icons.add, active: false, label: "New Task"),
          _sidebarIcon(Icons.search, label: "Search"),
          _sidebarIcon(Icons.home, active: true, label: "Home"),
          _sidebarIcon(Icons.folder_open, label: "Files"),
          _sidebarIcon(Icons.history, label: "History"),
          const Spacer(),
          _sidebarIcon(Icons.settings, label: "Settings"),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData icon, {bool active = false, String? label}) {
    return Builder(
      builder: (context) => Tooltip(
        message: label ?? "",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: InkWell(
            onTap: () => _showFeedback(context, label ?? "Action"),
            child: Icon(
              icon, 
              color: active ? const Color(0xFF6C63FF) : Colors.black45,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  void _showFeedback(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$action function coming soon!"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF6C63FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    return Row(
      children: [
        const Text("HealthLink AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const Spacer(),
        _navItem(context, "Dashboard", active: true),
        _navItem(context, "Schedule"),
        _navItem(context, "Patients"),
      ],
    );
  }

  Widget _navItem(BuildContext context, String label, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: InkWell(
        onTap: () => _showFeedback(context, label),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.black45,
            fontWeight: active ? FontWeight.bold : FontWeight.normal
          ),
        ),
      ),
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(maxWidth: 700),
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
              Text("Save Progress", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Sign in to track patient records", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          _authButton(
            context,
            icon: FontAwesomeIcons.google, 
            label: "Google", 
            onPressed: () => _showFeedback(context, "Google Login"),
            color: Colors.white,
            textColor: Colors.black,
            border: true,
          ),
          const SizedBox(width: 12),
          _authButton(
            context,
            icon: Icons.email_outlined, 
            label: "Email", 
            onPressed: () => _showFeedback(context, "Email Login"),
            color: const Color(0xFF6C63FF),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _authButton(
    BuildContext context, {
    required IconData icon, 
    required String label, 
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
    bool border = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon, size: 16, color: textColor),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
