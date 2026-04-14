import 'package:flutter/material.dart';
import 'register_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _sembunyikanPassword = true;
  bool _sedangMemuat = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan kata sandi tidak boleh kosong'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _sedangMemuat = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _sedangMemuat = false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Logo & Judul
              Center(
                child: Column(
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/415/415733.png',
                      width: 90,
                      height: 90,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.health_and_safety,
                        size: 90,
                        color: Color(0xFF2979FF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Catatan Makan Diabetes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pantau makanan & gula darah Anda',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Email
              _buildLabel('Email'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Masukkan Email'),
              ),

              const SizedBox(height: 16),

              // Kata Sandi
              _buildLabel('Kata Sandi'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _sembunyikanPassword,
                decoration: _inputDecoration('••••••••').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _sembunyikanPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () => setState(() => _sembunyikanPassword = !_sembunyikanPassword),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: _sedangMemuat ? null : _handleLogin,
                  child: _sedangMemuat
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('MASUK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),

              const SizedBox(height: 20),

              // Link Daftar
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? ', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                      child: const Text('Daftar', style: TextStyle(fontSize: 13, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String teks) {
    return Text(teks, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}