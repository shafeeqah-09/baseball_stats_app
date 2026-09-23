import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


final List<String> baseballFacts = [
  'The first World Series was played in 1903.',
  'A baseball has 108 stitches.',
  'The fastest pitch ever recorded was 105.1 mph by Aroldis Chapman.',
  'Babe Ruth hit 714 home runs in his career.',
  'The longest game in MLB history lasted 25 innings.',
  'A perfect game has only happened 23 times in MLB history.',
  'The average baseball game lasts about 3 hours.',
  'Jackie Robinson broke the color barrier in 1947.',
  'The youngest player to hit a home run was 15 years old.',
  'Yankee Stadium is called "The House That Ruth Built".',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB3T64J85s58tQywfUShL4TPJ7_Fu42VqE",
      authDomain: "baseball-stats-app-51330.firebaseapp.com",
      projectId: "baseball-stats-app-51330",
      storageBucket: "baseball-stats-app-51330.firebasestorage.app",
      messagingSenderId: "487815004496",
      appId: "1:487815004496:web:be3d51df1affa51f136c55",
    ),
  );
  runApp(const BaseballApp());
}

class BaseballApp extends StatelessWidget {
  const BaseballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baseball Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (snapshot.hasData) {
          return const PlayerListScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signup() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() => errorMessage = 'Enter your email first');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() => errorMessage = 'Reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.8),
            radius: 1.2,
            colors: [
              Color(0xFF1A3A6B),
              Color(0xFF0B1F3A),
              Color(0xFF05101F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnimatedBaseballHeader(),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (errorMessage != null)
                  Text(errorMessage!, style: const TextStyle(color: Colors.orange)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : signup,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                      side: const BorderSide(color: Color(0xFF1976D2), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: isLoading ? null : resetPassword,
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class PlayerListScreen extends StatelessWidget {
  const PlayerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: ListView(
        children: [
          // ACCOUNT SECTION
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A6B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFD32F2F),
                  child: Text(
                    user?.email?[0].toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SIGNED IN AS',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'PLAYERS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _playerTile(context, 'Shohei Ohtani', 'Dodgers', '0.310', '44', '95', '20'),
          _playerTile(context, 'Aaron Judge', 'Yankees', '0.280', '48', '110', '8'),
          _playerTile(context, 'Mookie Betts', 'Dodgers', '0.300', '35', '80', '15'),
        ],
      ),
    );
  }

  Widget _playerTile(
      BuildContext context,
      String name,
      String team,
      String avg,
      String hr,
      String rbi,
      String sb,
      ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF1976D2),
        child: Text(name[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text('$team • AVG: $avg', style: const TextStyle(color: Colors.white70)),
      trailing: Text('HR: $hr', style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerDetailScreen(
              name: name,
              team: team,
              avg: avg,
              hr: hr,
              rbi: rbi,
              sb: sb,
            ),
          ),
        );
      },
    );
  }
}
class AnimatedBaseballHeader extends StatefulWidget {
  const AnimatedBaseballHeader({super.key});

  @override
  State<AnimatedBaseballHeader> createState() => _AnimatedBaseballHeaderState();
}

class _AnimatedBaseballHeaderState extends State<AnimatedBaseballHeader>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _swingController;
  late AnimationController _ballController;

  late Animation<double> _glow;
  late Animation<double> _batSwing;
  late Animation<double> _ballFly;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _batSwing = Tween<double>(begin: -0.4, end: 0.4).animate(
      CurvedAnimation(parent: _swingController, curve: Curves.easeInOut),
    );

    _ballController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _ballFly = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ballController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _swingController.dispose();
    _ballController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _glow,
            builder: (context, child) {
              return Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(_glow.value * 0.7),
                      blurRadius: 30 * _glow.value,
                      spreadRadius: 10 * _glow.value,
                    ),
                    BoxShadow(
                      color: Colors.lightBlue.withOpacity(_glow.value * 0.4),
                      blurRadius: 60 * _glow.value,
                      spreadRadius: 15 * _glow.value,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_baseball,
                  size: 100,
                  color: Colors.white,
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            bottom: 30,
            child: AnimatedBuilder(
              animation: _batSwing,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _batSwing.value,
                  alignment: Alignment.bottomCenter,
                  child: const Icon(
                    Icons.sports_baseball_outlined,
                    size: 70,
                    color: Colors.brown,
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 0 - (_ballFly.value * 80),
            top: 20 - (_ballFly.value * 20),
            child: AnimatedBuilder(
              animation: _ballFly,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - _ballFly.value,
                  child: Transform.scale(
                    scale: 1 - (_ballFly.value * 0.5),
                    child: const Icon(
                      Icons.sports_baseball,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late String _fact;

  @override
  void initState() {
    super.initState();
    _fact = baseballFacts[DateTime.now().microsecond % baseballFacts.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.8),
            radius: 1.2,
            colors: [
              Color(0xFF1A3A6B),
              Color(0xFF0B1F3A),
              Color(0xFF05101F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 30),
                const Icon(Icons.sports_baseball, size: 60, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'DID YOU KNOW?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _fact,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerDetailScreen extends StatefulWidget {
  final String name;
  final String team;
  final String avg;
  final String hr;
  final String rbi;
  final String sb;

  const PlayerDetailScreen({
    super.key,
    required this.name,
    required this.team,
    required this.avg,
    required this.hr,
    required this.rbi,
    required this.sb,
  });

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();
    _lastUpdated = DateTime.now();
  }

  void _refresh() {
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }

  String _timeAgo() {
    final diff = DateTime.now().difference(_lastUpdated);
    if (diff.inSeconds < 60) return 'Updated just now';
    if (diff.inMinutes < 60) return 'Updated ${diff.inMinutes} min ago';
    return 'Updated ${diff.inHours} hr ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.8),
            radius: 1.2,
            colors: [
              Color(0xFF1A3A6B),
              Color(0xFF0B1F3A),
              Color(0xFF05101F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFD32F2F),
                    child: Text(
                      widget.name[0],
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    widget.team,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    _timeAgo(),
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 30),
                _statRow('Batting Average', widget.avg),
                _statRow('Home Runs', widget.hr),
                _statRow('RBIs', widget.rbi),
                _statRow('Stolen Bases', widget.sb),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A6B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}