import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();
  bool _sembunyikanPassword = true;
  bool _sembunyikanKonfirmasi = true;
  bool _sedangMemuat = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _handleDaftar() async {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final konfirmasi = _konfirmasiPasswordController.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty || konfirmasi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (password != konfirmasi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi tidak cocok'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _sedangMemuat = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _sedangMemuat = false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Kembali
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),

              const SizedBox(height: 12),

              // Logo & Judul
              Center(
                child: Column(
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/415/415733.png',
                      width: 80, height: 80,
                      errorBuilder: (_, __, ___) => const Icon(Icons.health_and_safety, size: 80, color: Color(0xFF2979FF)),
                    ),
                    const SizedBox(height: 12),
                    const Text('Buat Akun', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              _buildLabel('Nama'),
              const SizedBox(height: 8),
              _buildTextField(controller: _namaController, hint: 'Masukkan Nama'),

              const SizedBox(height: 16),

              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(controller: _emailController, hint: 'Masukkan Email', jenisKeyboard: TextInputType.emailAddress),

              const SizedBox(height: 16),

              _buildLabel('Kata Sandi'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: '••••••••',
                sembunyikan: _sembunyikanPassword,
                onToggle: () => setState(() => _sembunyikanPassword = !_sembunyikanPassword),
              ),

              const SizedBox(height: 16),

              _buildLabel('Konfirmasi Kata Sandi'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _konfirmasiPasswordController,
                hint: '••••••••',
                sembunyikan: _sembunyikanKonfirmasi,
                onToggle: () => setState(() => _sembunyikanKonfirmasi = !_sembunyikanKonfirmasi),
              ),

              const SizedBox(height: 28),

              // Tombol Daftar
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
                  onPressed: _sedangMemuat ? null : _handleDaftar,
                  child: _sedangMemuat
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('DAFTAR', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),

              const SizedBox(height: 20),

              // Link Masuk
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun? ', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                      child: const Text('Masuk', style: TextStyle(fontSize: 13, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool sembunyikan = false,
    TextInputType jenisKeyboard = TextInputType.text,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: sembunyikan,
      keyboardType: jenisKeyboard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        suffixIcon: onToggle != null
            ? IconButton(
                icon: Icon(sembunyikan ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[400], size: 20),
                onPressed: onToggle,
              )
            : null,
      ),
    );
  }
}