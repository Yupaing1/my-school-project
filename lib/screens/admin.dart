import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'video_list_screen.dart';
import 'upload_video_screen.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar (ဘယ်ဘက် navigation)
          Container(
            width: 280,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(5, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Profile Circle
                Animate(
                  effects: const [FadeEffect(), ScaleEffect()],
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // User Name / Greeting
                Text(
                  "မင်္ဂလာပါ",
                  style: GoogleFonts.notoSansMyanmar(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  user?.displayName ?? "User",
                  style: GoogleFonts.notoSansMyanmar(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 60),

                // Sidebar Menu Items
                _buildSidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: "Dashboard",
                  isSelected: true,
                ),
                _buildSidebarItem(
                  icon: Icons.video_library_rounded,
                  label: "Videos",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoListScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.upload_file_rounded,
                  label: "Upload Video",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UploadVideoScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.analytics_rounded,
                  label: "Analytics",
                ),
                _buildSidebarItem(
                  icon: Icons.settings_rounded,
                  label: "Settings",
                ),
                _buildSidebarItem(
                  icon: Icons.notifications_rounded,
                  label: "Notifications",
                ),

                const Spacer(flex: 4),

                // Logout at bottom
                _buildSidebarItem(
                  icon: Icons.logout_rounded,
                  label: "Logout",
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),

          // Main Content Area (ညာဘက်)
          Expanded(
            child: Container(
              color: const Color(0xFFFAFDFF),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Animate(
                    effects: const [
                      FadeEffect(),
                      SlideEffect(begin: Offset(0, -0.2)),
                    ],
                    child: Text(
                      "Welcome back, ${user?.displayName ?? 'User'} 👋",
                      style: GoogleFonts.notoSansMyanmar(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Cards Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      children: [
                        _buildDashboardCard(
                          title: "Total Videos",
                          value: "24",
                          icon: Icons.video_collection_rounded,
                          color: const Color(0xFF42A5F5),
                        ),
                        _buildDashboardCard(
                          title: "Views Today",
                          value: "1,248",
                          icon: Icons.visibility_rounded,
                          color: const Color(0xFF43A047),
                        ),
                        _buildDashboardCard(
                          title: "New Uploads",
                          value: "3",
                          icon: Icons.upload_file_rounded,
                          color: const Color(0xFFFFCA28),
                        ),
                        _buildDashboardCard(
                          title: "Active Users",
                          value: "156",
                          icon: Icons.people_rounded,
                          color: const Color(0xFFAB47BC),
                        ),
                        _buildDashboardCard(
                          title: "Storage Used",
                          value: "4.2 GB",
                          icon: Icons.storage_rounded,
                          color: const Color(0xFFEF5350),
                        ),
                        _buildDashboardCard(
                          title: "Pending Reviews",
                          value: "5",
                          icon: Icons.pending_actions_rounded,
                          color: const Color(0xFFFF7043),
                        ),
                      ],
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

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Animate(
      effects: const [
        FadeEffect(),
        SlideEffect(begin: Offset(-0.2, 0)),
      ],
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
        title: Text(
          label,
          style: GoogleFonts.notoSansMyanmar(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Animate(
      effects: const [FadeEffect(), ScaleEffect()],
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                value,
                style: GoogleFonts.notoSansMyanmar(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.notoSansMyanmar(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
