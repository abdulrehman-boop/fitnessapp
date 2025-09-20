import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dietexdetail.dart';

class GymExercisePage extends StatefulWidget {
  final String animations;

  const GymExercisePage({super.key, required this.animations});

  @override
  State<GymExercisePage> createState() => _GymExercisePageState();
}

class _GymExercisePageState extends State<GymExercisePage> with SingleTickerProviderStateMixin {
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 8,
        centerTitle: true,
        title: Text(
          'Gym Exercise',
          style: GoogleFonts.montserrat(
            color: Colors.tealAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Lottie.asset(
              widget.animations,
              height: 240,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildExerciseCard(
                    icon: Icons.fitness_center,
                    title: 'For Muscle Gain',
                    description: '''• Meal 1: Oats with peanut butter and banana
• Meal 2: Chicken breast with rice and broccoli
• Meal 3: Greek yogurt with almonds
• Meal 4: Eggs and whole grain toast
• Meal 5: Whey protein shake after workout
• Meal 6: Salmon and sweet potato''',
                    gradientColors: [Colors.teal.shade700, Colors.teal.shade400],
                  ),
                  SizedBox(height: 20),
                  _buildExerciseCard(
                    icon: Icons.local_fire_department,
                    title: 'For Weight Loss',
                    description: '''• Meal 1: Boiled eggs with green tea
• Meal 2: Grilled chicken salad with olive oil
• Meal 3: Apple or mixed berries
• Meal 4: Baked fish with veggies
• Meal 5: Low-fat cottage cheese
• Meal 6: Herbal tea with a handful of nuts''',
                    gradientColors: [Colors.deepOrange.shade800, Colors.deepOrange.shade500],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DietDetailPage(title: title, description: description),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 30,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
