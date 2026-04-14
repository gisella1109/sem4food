import 'package:flutter/material.dart';
import 'blood_sugar_analysis_page.dart';
import 'food_photo_input_page.dart';
import 'health_profile_page.dart';
import 'meal_history_page.dart';

class FoodAnalysisPage extends StatefulWidget {
  final String namaMakanan;
  final String waktuMakan;

  const FoodAnalysisPage({
    super.key,
    this.namaMakanan = 'Nasi Goreng Telur',
    this.waktuMakan = 'Sarapan',
  });

  @override
  State<FoodAnalysisPage> createState() => _FoodAnalysisPageState();
}

class _FoodAnalysisPageState extends State<FoodAnalysisPage> {
  int _indeksAktif = 1; // Jurnal/Laporan aktif

  void _simpanKeJurnal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil disimpan ke jurnal!'),
        backgroundColor: Color(0xFF2979FF),
        duration: Duration(seconds: 1),
      ),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MealHistoryPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analisis Makanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Foto Makanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.amber[100],
                      child: const Center(
                        child: Icon(Icons.restaurant, size: 80, color: Colors.orange),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2979FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Foto Anda',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Label AI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF2979FF)),
                  const SizedBox(width: 6),
                  Text(
                    'ANALISIS AI GLUCOGUIDE',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[400], letterSpacing: 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Nama Makanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.namaMakanan,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Porsi standar (sekitar 250g) • ${widget.waktuMakan}',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ),

            const SizedBox(height: 20),

            // Grid Nutrisi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildKartuNutrisi('450', 'KCAL'),
                  const SizedBox(width: 10),
                  _buildKartuNutrisi('55g', 'KARBO'),
                  const SizedBox(width: 10),
                  _buildKartuNutrisi('12g', 'PROTEIN'),
                  const SizedBox(width: 10),
                  _buildKartuNutrisi('18g', 'LEMAK'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Peringatan Kadar Gula
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Peringatan Kadar Gula',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFE65100))),
                          const SizedBox(height: 6),
                          Text(
                            'Nasi goreng ini mengandung karbohidrat tinggi (55g). Disarankan untuk menambah sayuran atau membagi porsi untuk menjaga gula darah tetap stabil.',
                            style: TextStyle(fontSize: 13, color: Colors.orange[800], height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Tombol Simpan ke Jurnal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _simpanKeJurnal,
                  icon: const Icon(Icons.save_outlined, size: 20),
                  label: const Text('Simpan ke Jurnal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tombol Edit Detail
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2979FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(color: Colors.grey[300]!),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.edit_note_outlined, size: 20),
                  label: const Text('Edit Detail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Bottom Nav sama seperti Dashboard
      bottomNavigationBar: _buildNavBawah(context),
    );
  }

  Widget _buildKartuNutrisi(String nilai, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(nilai, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBawah(BuildContext context) {
    final daftarMenu = [
      {'ikon': Icons.home_rounded, 'label': 'Beranda'},
      {'ikon': Icons.bar_chart_rounded, 'label': 'Laporan'},
      {'ikon': null, 'label': 'Tambah'},
      {'ikon': Icons.history_rounded, 'label': 'Riwayat'},
      {'ikon': Icons.person_outline_rounded, 'label': 'Profil'},
    ];

    final halamanTujuan = [
      null,
      const BloodSugarAnalysisPage(),
      null,
      const MealHistoryPage(),
      const HealthProfilePage(),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(daftarMenu.length, (i) {
          if (i == 2) {
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodPhotoInputPage())),
              child: Container(
                width: 52, height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF2979FF),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0x442979FF), blurRadius: 12, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            );
          }

          final aktif = _indeksAktif == i;
          return GestureDetector(
            onTap: () {
              setState(() => _indeksAktif = i);
              if (halamanTujuan[i] != null) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => halamanTujuan[i]!));
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(daftarMenu[i]['ikon'] as IconData,
                  color: aktif ? const Color(0xFF2979FF) : Colors.grey[400], size: 24),
                const SizedBox(height: 3),
                Text(daftarMenu[i]['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: aktif ? const Color(0xFF2979FF) : Colors.grey[400],
                    fontWeight: aktif ? FontWeight.w600 : FontWeight.normal,
                  )),
              ],
            ),
          );
        }),
      ),
    );
  }
}