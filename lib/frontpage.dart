import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'api/auth_service.dart';
import 'dietplanpage.dart';
import 'gymexercisepage.dart';
import 'settings_page.dart';
import 'workoutpage.dart';

class Front extends StatefulWidget {
  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> {
  int _selectedNavIndex = 0;
  bool _isDarkTheme = false;
  User? _user;
  int _notificationCount = 0;

  final List<String> _gridTitles = [
    'Diet Plan',
    'Gym Exercise',
    'Cheat Meal',
    'Meal Prep',
    'Supplements',
    'Sleep Guide',
  ];

  final List<String> _animations = [
    "assets/animations/gym3.json",
    "assets/animations/gym2.json",
    "assets/animations/gym3.json",
    "assets/animations/gym3.json",
    "assets/animations/gym2.json",
    "assets/animations/gym3.json",
  ];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _setupFCMListener();
  }

  void _setupFCMListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _notificationCount++;
      });
    });
  }

  void _onBottomNavTap(int index) {
    setState(() => _selectedNavIndex = index);
  }

  void _handleLogin() async {
    final user = await AuthService().signInWithGoogle();
    if (user != null) {
      setState(() => _user = user);
    }
  }

  void _handleLogout() async {
    await AuthService().signOut();
    setState(() => _user = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor: _isDarkTheme ? Color(0xFF121212) : Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 10,
          iconTheme: IconThemeData(color: Colors.tealAccent),
          title: Text(
            'Fitness Pro',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_none, color: Colors.tealAccent),
                  onPressed: () {
                    // You can navigate to a notifications page here
                    setState(() => _notificationCount = 0); // Reset badge
                  },
                ),
                if (_notificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$_notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: _isDarkTheme ? Colors.black : Colors.grey[850],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade700, Colors.teal.shade400],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _user?.photoURL != null
                        ? NetworkImage(_user!.photoURL!)
                        : null,
                    child: _user?.photoURL == null
                        ? Icon(Icons.person, color: Colors.black)
                        : null,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _user?.displayName ?? "Welcome User",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Home', style: GoogleFonts.poppins(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: GoogleFonts.poppins(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      isDarkTheme: _isDarkTheme,
                      onThemeChanged: (val) {
                        setState(() => _isDarkTheme = val);
                      },
                    ),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: Text('Dark Theme', style: GoogleFonts.poppins(color: Colors.white)),
              secondary: Icon(Icons.dark_mode, color: Colors.white),
              value: _isDarkTheme,
              onChanged: (val) {
                setState(() => _isDarkTheme = val);
              },
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(_user == null ? Icons.login : Icons.logout, color: Colors.white),
              title: Text(
                _user == null ? "Sign in with Google" : "Logout",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: _user == null ? _handleLogin : _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedNavIndex) {
      case 0:
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildFitnessSummaryCard(),
                SizedBox(height: 24),
                _buildGridMenu(),
              ],
            ),
          ),
        );
      case 1:
        return WorkoutPage(isDarkTheme: _isDarkTheme);
      case 2:
        return _buildProfilePage();
      default:
        return Center(child: Text("Page Not Found"));
    }
  }

  Widget _buildFitnessSummaryCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            _isDarkTheme ? Color(0xFF212121) : Color(0xFF00ACC1),
            _isDarkTheme ? Color(0xFF1B1B1B) : Color(0xFF00796B),
          ],
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
            child: Lottie.asset(
              'assets/animations/calories.json',
              width: 130,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Burn Calories",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Track your calorie burn with daily workouts",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.local_fire_department, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildGridMenu() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(_gridTitles.length, (index) {
        return GestureDetector(
          onTap: () {
            final title = _gridTitles[index];
            if (title == 'Gym Exercise') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => DietPlanPage(animations: _animations[index]),
              ));
            } else if (title == 'Diet Plan') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => GymExercisePage(animations: _animations[index]),
              ));
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            color: _isDarkTheme ? Color(0xFF1E1E1E) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    _animations[index],
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 12),
                  Text(
                    _gridTitles[index],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isDarkTheme ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: _selectedNavIndex,
      onTap: _onBottomNavTap,
      selectedItemColor: Colors.tealAccent,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Workouts"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  Widget _buildProfilePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _user?.photoURL != null
                  ? NetworkImage(_user!.photoURL!)
                  : null,
              child: _user?.photoURL == null
                  ? Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
              backgroundColor: Colors.teal,
            ),
            SizedBox(height: 12),
            Text(
              _user?.displayName ?? "Guest User",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard("Workouts", "24"),
                _buildStatCard("Time (hrs)", "12"),
                _buildStatCard("Calories", "3.2k"),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Your Goals", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 8),
            _buildGoalProgress("Weekly Workouts", 0.7),
            _buildGoalProgress("Calories Burn", 0.5),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Achievements", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildBadge("🔥 Streak x7"),
                _buildBadge("💪 100 Workouts"),
                _buildBadge("🏅 5k Calories Burned"),
                _buildBadge("🧘‍♂️ Wellness Master"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildGoalProgress(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 14)),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          minHeight: 8,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.teal, fontWeight: FontWeight.w500),
      ),
    );
  }
}
