import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dietexdetail.dart';

class DietPlanPage extends StatefulWidget {
  final String animations;
  DietPlanPage({required this.animations});

  @override
  State<DietPlanPage> createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 10,
        title: Text(
          'Gym Exercise',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.tealAccent),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Lottie.asset(
              widget.animations,
              height: 250,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildDietCard(
                    icon: Icons.fitness_center_rounded,
                    title: 'Strength Training',
                    color1: Colors.teal.shade600,
                    color2: Colors.teal.shade400,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DietDetailPage(
                            title: 'Strength Training',
                            description:
                            "Strength training focuses on building muscle mass and strength. This includes exercises like squats, deadlifts, bench press, and overhead press.",
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDietCard(
                    icon: Icons.local_fire_department,
                    title: 'Fat Burn Workout',
                    color1: Colors.deepOrange.shade900, // ✅ FIXED: split gradientColors into color1/color2
                    color2: Colors.deepOrange.shade600,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DietDetailPage(
                            title: 'Fat Burn Workout',
                            description:
                            "Fat burn workouts are high-intensity routines designed to raise your heart rate and burn calories. This includes HIIT, circuit training, and cardio-based movements.",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietCard({
    required IconData icon,
    required String title,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color1.withOpacity(0.95), color2.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white.withOpacity(0.15),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
