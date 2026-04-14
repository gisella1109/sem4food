import 'package:flutter/material.dart';
import 'food_analysis_page.dart';

class FoodPhotoInputPage extends StatefulWidget {
  const FoodPhotoInputPage({super.key});

  @override
  State<FoodPhotoInputPage> createState() => _FoodPhotoInputPageState();
}

class _FoodPhotoInputPageState extends State<FoodPhotoInputPage> {
  final _namaMakananController = TextEditingController();
  int _waktuMakanDipilih = 0; // 0=Sarapan, 1=Siang, 2=Malam, 3=Cemilan
  bool _fotoSudahDipilih = false;

  final List<Map<String, dynamic>> _daftarWaktuMakan = [
    {'label': 'Sarapan', 'ikon': Icons.wb_sunny_outlined},
    {'label': 'Siang', 'ikon': Icons.wb_sunny},
    {'label': 'Malam', 'ikon': Icons.dark_mode},
    {'label': 'Cemilan', 'ikon': Icons.cookie_outlined},
  ];

  @override
  void dispose() {
    _namaMakananController.dispose();
    super.dispose();
  }

  void _simpanDanAnalisis() {
    if (_namaMakananController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap masukkan nama makanan'), backgroundColor: Colors.redAccent),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodAnalysisPage(
          namaMakanan: _namaMakananController.text.trim(),
          waktuMakan: _daftarWaktuMakan[_waktuMakanDipilih]['label'] as String,
        ),
      ),
    );
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
          'Input Foto Makanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Area Upload Foto
            GestureDetector(
              onTap: () => setState(() => _fotoSudahDipilih = false),
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2979FF).withValues(alpha: 0.35), width: 2,
                    style: BorderStyle.solid),
                ),
                child: _fotoSudahDipilih
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              color: Colors.blue[100],
                              child: const Center(child: Icon(Icons.image, size: 80, color: Color(0xFF2979FF))),
                            ),
                          ),
                          Positioned(
                            top: 10, right: 10,
                            child: GestureDetector(
                              onTap: () => setState(() => _fotoSudahDipilih = false),
                              child: Container(
                                width: 30, height: 30,
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.close, size: 16, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2979FF).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF2979FF), size: 30),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ambil atau Pilih Foto',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pastikan makanan terlihat jelas untuk\nestimasi karbohidrat yang akurat',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey[500], height: 1.5),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Ambil Foto & Galeri
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () => setState(() => _fotoSudahDipilih = true),
                    icon: const Icon(Icons.camera_alt_outlined, size: 20),
                    label: const Text('Ambil Foto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A1A2E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey[300]!),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () => setState(() => _fotoSudahDipilih = true),
                    icon: const Icon(Icons.photo_library_outlined, size: 20),
                    label: const Text('Galeri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Nama Makanan
            const Text('Nama Makanan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: TextField(
                controller: _namaMakananController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Nasi Merah & Ayam Bakar',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Waktu Makan
            const Text('Waktu Makan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              children: List.generate(_daftarWaktuMakan.length, (i) {
                final dipilih = _waktuMakanDipilih == i;
                return GestureDetector(
                  onTap: () => setState(() => _waktuMakanDipilih = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: dipilih ? const Color(0xFFEAF2FF) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: dipilih ? const Color(0xFF2979FF) : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _daftarWaktuMakan[i]['ikon'] as IconData,
                          size: 20,
                          color: dipilih ? const Color(0xFF2979FF) : Colors.grey[500],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _daftarWaktuMakan[i]['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: dipilih ? FontWeight.bold : FontWeight.normal,
                            color: dipilih ? const Color(0xFF2979FF) : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Tombol Simpan & Analisis
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _simpanDanAnalisis,
                child: const Text(
                  'Simpan & Analisis',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Keterangan AI
            Center(
              child: Text(
                'AI kami akan menghitung estimasi karbohidrat\nberdasarkan foto yang Anda unggah.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[500], fontStyle: FontStyle.italic, height: 1.5),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}