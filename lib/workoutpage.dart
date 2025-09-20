import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
class WorkoutPage extends StatelessWidget {
  final bool isDarkTheme;
  WorkoutPage({required this.isDarkTheme});
  final List<Map<String, dynamic>> workouts = [
    {
      'title': 'Full Body Blast',
      'duration': '45 mins',
      'icon': LucideIcons.dumbbell
    },
    {
      'title': 'HIIT Cardio',
      'duration': '30 mins',
      'icon': LucideIcons.activity
    },
    {
      'title': 'Core Strength',
      'duration': '25 mins',
      'icon': LucideIcons.shield
    },
    {
      'title': 'Yoga Flow',
      'duration': '40 mins',
      'icon': LucideIcons.leaf
    },
  ];
  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkTheme ? const Color(0xFF121212) : Colors.grey[100];
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Workouts',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return WorkoutCard(
              title: workout['title'],
              duration: workout['duration'],
              icon: workout['icon'],
              isDark: isDarkTheme,
            );
          },
        ),
      ),
    );
  }
}
class WorkoutCard extends StatelessWidget {
  final String title;
  final String duration;
  final IconData icon;
  final bool isDark;
  const WorkoutCard({
    required this.title,
    required this.duration,
    required this.icon,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Color(0xFF1B1B1B), Color(0xFF212121)]
              : [Color(0xFF00ACC1), Color(0xFF00796B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.tealAccent,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          duration,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54),
        onTap: () {
          // Navigate to detailed workout screen
        },
      ),
    );
  }
}
