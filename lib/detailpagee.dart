// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// class DetailScreen extends StatefulWidget {
//
//   final String animations;
//   DetailScreen({required this.animations});
//   @override
//   _DetailScreenState createState() => _DetailScreenState();
// }
//
// class _DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.teal.shade800,
//         title: Text(
//           'Fitness App',
//           style: GoogleFonts.poppins(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 6,
//         shadowColor: Colors.black38,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Lottie.asset(
//               widget.animations,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }