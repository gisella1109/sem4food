import 'package:flutter/material.dart';

class MealHistoryPage extends StatelessWidget {
  const MealHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> daftarRiwayat = [
      {
        'nama': 'Nasi Goreng Telur',
        'waktu': 'Hari ini, 08:00 • Sarapan',
        'kalori': 450,
        'karbo': 55,
        'warna': const Color(0xFFFF8C00),
        'peringatan': true,
      },
      {
        'nama': 'Ayam Bakar + Sayur',
        'waktu': 'Kemarin, 12:30 • Siang',
        'kalori': 320,
        'karbo': 28,
        'warna': const Color(0xFF2979FF),
        'peringatan': false,
      },
      {
        'nama': 'Buah Potong',
        'waktu': 'Kemarin, 15:00 • Cemilan',
        'kalori': 90,
        'karbo': 22,
        'warna': Colors.green,
        'peringatan': false,
      },
      {
        'nama': 'Soto Ayam',
        'waktu': 'Selasa, 19:00 • Malam',
        'kalori': 380,
        'karbo': 42,
        'warna': const Color(0xFFFF8C00),
        'peringatan': true,
      },
    ];

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
          'Riwayat Makan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF2979FF)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Ringkasan Harian
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2979FF), Color(0xFF448AFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRingkasan('1.240', 'Total Kalori'),
                  _buildPemisah(),
                  _buildRingkasan('147g', 'Total Karbo'),
                  _buildPemisah(),
                  _buildRingkasan('4', 'Entri Hari Ini'),
                ],
              ),
            ),
          ),

          // Label Tanggal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('HARI INI',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 1)),
              ],
            ),
          ),

          // Daftar Riwayat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: daftarRiwayat.length,
              itemBuilder: (context, i) => _buildItemRiwayat(context, daftarRiwayat[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingkasan(String nilai, String label) {
    return Column(
      children: [
        Text(nilai, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }

  Widget _buildPemisah() {
    return Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.3));
  }

  Widget _buildItemRiwayat(BuildContext context, Map<String, dynamic> item) {
    final bool adaPeringatan = item['peringatan'] as bool;
    final Color warna = item['warna'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Ikon makanan
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: warna.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restaurant, color: warna, size: 24),
            ),
            const SizedBox(width: 14),

            // Info makanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['nama'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                        ),
                      ),
                      if (adaPeringatan)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('⚠ Tinggi', style: TextStyle(fontSize: 10, color: Color(0xFFE65100), fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item['waktu'], style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildChipNutrisi('${item['kalori']} kkal', const Color(0xFF2979FF)),
                      const SizedBox(width: 8),
                      _buildChipNutrisi('${item['karbo']}g karbo',
                          adaPeringatan ? const Color(0xFFE65100) : Colors.green),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildChipNutrisi(String teks, Color warna) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(teks, style: TextStyle(fontSize: 11, color: warna, fontWeight: FontWeight.w600)),
    );
  }
}