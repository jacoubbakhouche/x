import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../chat/screens/chat_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
           Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E1E2E), Color(0xFF2A2D46)],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 32),
                  
                  // Main Dashboard Grid
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column: 3D Body & Schedule
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    _buildAnatomyCard(),
                                    const SizedBox(height: 20),
                                    _buildScheduleCard(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              
                              // Right Column: Stats & AI Action
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                     _buildStatCard("Heart Rate", "80-90 bpm", Icons.favorite, Colors.redAccent),
                                     const SizedBox(height: 20),
                                     _buildStatCard("Brain Activity", "90-150 Hz", Icons.waves, Colors.orangeAccent),
                                     const SizedBox(height: 20),
                                     _buildAIActionCard(context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Online Consultation Doctors
                          _buildDoctorsSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF6C63FF).withOpacity(0.2),
          child: const Icon(Icons.medical_services, color: Color(0xFF6C63FF)),
        ),
        const SizedBox(width: 12),
        const Text(
          "HealthLink", 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
        ),
        const Spacer(),
        _headerButton(Icons.dashboard, "Dashboard", active: true),
        const SizedBox(width: 16),
        _headerButton(Icons.calendar_today, "Appointments"),
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 20,
           backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
        )
      ],
    );
  }

  Widget _headerButton(IconData icon, String label, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6C63FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAnatomyCard() {
    return GlassmorphicContainer(
       width: double.infinity,
       height: 350,
       borderRadius: 24,
       blur: 20,
       alignment: Alignment.center,
       border: 1,
       linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
       borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]),
       child: Stack(
         children: [
           Positioned(
             top: 20, left: 20,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: const [
                 Text("Hi Doctor!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                 Text("Patient Overview", style: TextStyle(fontSize: 16, color: Colors.grey)),
               ],
             ),
           ),
           // Placeholder for 3D body image
           Align(
             alignment: Alignment.bottomRight,
             child: Opacity(
               opacity: 0.8,
               child: Image.network(
                 "https://ouch-cdn2.icons8.com/6U4g0X4Z3w8k0Z5Y0d1c8f4h5j2k9l3m7n6o0p4q2r5s.png", // Creative commons medical illustration
                 height: 300,
                 errorBuilder: (ctx, err, stack) => const Icon(Icons.person, size: 200, color: Colors.white10),
               ),
             ),
           )
         ],
       ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2F45),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Care Schedule", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                child: const Text("Sep 2026", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
          const SizedBox(height: 20),
          _scheduleItem("12:00", "Blood Pressure Check", "Measure BP at rest", Colors.blueAccent),
          _scheduleItem("14:00", "Dr. John Consultation", "Prepare 3 BP readings", Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _scheduleItem(String time, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: color, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF2D2F45), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAIActionCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      },
      child: Container(
        height: 180,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF4C43CD)]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
             Icon(Icons.auto_awesome, color: Colors.white, size: 32),
             SizedBox(height: 16),
             Text("Start AI Consultation", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
             SizedBox(height: 8),
             Text("Analyze symptoms with guidelines", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Online Consultation", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            _doctorCard("Dr. Sarah", "Cardiologist", "https://i.pravatar.cc/150?img=5"),
            const SizedBox(width: 16),
            _doctorCard("Dr. Mike", "Dentist", "https://i.pravatar.cc/150?img=3"),
          ],
        )
      ],
    );
  }

  Widget _doctorCard(String name, String role, String image) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF2D2F45), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
             CircleAvatar(backgroundImage: NetworkImage(image)),
             const SizedBox(width: 12),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                 Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
               ],
             )
          ],
        ),
      ),
    );
  }
}
