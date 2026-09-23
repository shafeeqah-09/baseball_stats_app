import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Baseball Stats')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedBaseballHeader(),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isLoading ? null : signup,
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerListScreen extends StatelessWidget {
  const PlayerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        children: const [
          ListTile(
            leading: CircleAvatar(child: Text('S')),
            title: Text('Shohei Ohtani'),
            subtitle: Text('Dodgers • AVG: 0.310'),
            trailing: Text('HR: 44'),
          ),
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Aaron Judge'),
            subtitle: Text('Yankees • AVG: 0.280'),
            trailing: Text('HR: 48'),
          ),
          ListTile(
            leading: CircleAvatar(child: Text('M')),
            title: Text('Mookie Betts'),
            subtitle: Text('Dodgers • AVG: 0.300'),
            trailing: Text('HR: 35'),
          ),
        ],
      ),
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