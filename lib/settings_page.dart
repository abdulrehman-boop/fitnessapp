import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  SettingsPage({required this.isDarkTheme, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool workoutReminder = true;
  String preferredWorkout = 'Cardio';
  String appTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkTheme ? Colors.black : Colors.grey[100];

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.poppins(color: Colors.tealAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      backgroundColor: backgroundColor,
      body: ListView(
        children: [
          _buildSwitchTile('Notifications', notificationsEnabled, (val) {
            setState(() => notificationsEnabled = val);
          }),
          _buildSwitchTile('Workout Reminder', workoutReminder, (val) {
            setState(() => workoutReminder = val);
          }),
          _buildDropdownTile(
            'Preferred Workout',
            ['Cardio', 'Strength', 'HIIT', 'Yoga'],
            preferredWorkout,
                (val) => setState(() => preferredWorkout = val),
            titleColor: Colors.black,
            dropdownTextColor: Colors.black,
          ),
          _buildDropdownTile(
            'Theme',
            ['Light', 'Dark'],
            widget.isDarkTheme ? 'Dark' : 'Light',
                (val) {
              widget.onThemeChanged(val == 'Dark');
              setState(() => appTheme = val);
            },
          ),
          const Divider(),
          ListTile(
            title: Text('Account Settings', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to account settings
            },
          ),
          ListTile(
            title: Text('Integrations', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to integrations
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: GoogleFonts.poppins()),
      activeColor: Colors.tealAccent,
    );
  }

  Widget _buildDropdownTile(
      String title,
      List<String> options,
      String currentValue,
      Function(String) onChanged, {
        Color? titleColor,
        Color? dropdownTextColor,
      }) {
    return ListTile(
      title: Text(title, style: GoogleFonts.poppins(color: titleColor ?? Colors.white)),
      trailing: DropdownButton<String>(
        value: currentValue,
        dropdownColor: Colors.white,
        style: GoogleFonts.poppins(color: dropdownTextColor ?? Colors.white),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: GoogleFonts.poppins(color: dropdownTextColor ?? Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}
