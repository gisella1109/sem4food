import 'package:flutter/material.dart';
import 'dart:math';
import '../models/glucose_store.dart';

class BloodSugarAnalysisPage extends StatefulWidget {
  const BloodSugarAnalysisPage({super.key});

  @override
  State<BloodSugarAnalysisPage> createState() => _BloodSugarAnalysisPageState();
}

class _BloodSugarAnalysisPageState extends State<BloodSugarAnalysisPage> {
  int _tabAktif = 1; // 0=Hari, 1=Minggu, 2=Bulan
  final List<String> _daftarTab = ['Hari', 'Minggu', 'Bulan'];

  // Data gula darah per hari (SEN-MIN)
  final _store = GlucoseStore();
  List<double> get _dataMingguan => _store.data7Hari.isNotEmpty ? _store.data7Hari : [88, 102, 97, 142, 118, 125, 131];
  final List<String> _labelHari = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];

  final List<Map<String, dynamic>> _riwayat = [
    {'nilai': 115, 'waktu': 'Hari ini, 08:00', 'keterangan': 'Sebelum Sarapan', 'warna': const Color(0xFF2979FF)},
    {'nilai': 142, 'waktu': 'Kemarin, 20:30', 'keterangan': 'Setelah Makan Malam', 'warna': const Color(0xFFFF8C00)},
    {'nilai': 98, 'waktu': 'Kemarin, 07:00', 'keterangan': 'Sebelum Sarapan', 'warna': const Color(0xFF2979FF)},
    {'nilai': 125, 'waktu': 'Selasa, 13:00', 'keterangan': 'Setelah Makan Siang', 'warna': const Color(0xFFFF8C00)},
  ];

  double get _rataRata => _dataMingguan.reduce((a, b) => a + b) / _dataMingguan.length;
  double get _tertinggi => _dataMingguan.reduce(max);
  double get _terendah => _dataMingguan.reduce(min);
  int get _indeksTertinggi => _dataMingguan.indexOf(_tertinggi);
  int get _indeksTerendah => _dataMingguan.indexOf(_terendah);

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
        title: const Text('Analisis Gula Darah',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildTabPeriode(),
            const SizedBox(height: 16),
            _buildKartuGrafik(),
            const SizedBox(height: 16),
            _buildGridStatistik(),
            const SizedBox(height: 20),
            _buildRiwayatTerakhir(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPeriode() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2E5EA),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(_daftarTab.length, (i) {
          final aktif = _tabAktif == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabAktif = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: aktif ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: aktif
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))]
                      : [],
                ),
                child: Text(
                  _daftarTab[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
                    color: aktif ? const Color(0xFF2979FF) : Colors.grey[500],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildKartuGrafik() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rata-rata Minggu Ini', style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                child: const Text('NORMAL', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _rataRata.toStringAsFixed(0),
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('mg/dL', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: _GrafikGaris(
              data: _dataMingguan,
              labelHari: _labelHari,
              indeksAktif: 3, // KAM
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _labelHari.asMap().entries.map((e) {
              final aktif = e.key == 3;
              return Text(
                e.value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
                  color: aktif ? const Color(0xFF2979FF) : Colors.grey[400],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridStatistik() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _buildKartuStat(
          ikon: Icons.trending_up,
          warnaIkon: const Color(0xFF2979FF),
          label: 'TERTINGGI',
          nilai: '${_tertinggi.toInt()} mg/dL',
          subjudul: '${_labelHari[_indeksTertinggi].toLowerCase().capitalize()}, 14:00',
        ),
        _buildKartuStat(
          ikon: Icons.trending_down,
          warnaIkon: const Color(0xFFFF8C00),
          label: 'TERENDAH',
          nilai: '${_terendah.toInt()} mg/dL',
          subjudul: '${_labelHari[_indeksTerendah].toLowerCase().capitalize()}, 06:30',
        ),
        _buildKartuStat(
          ikon: Icons.check_circle,
          warnaIkon: Colors.green,
          label: 'DALAM RENTANG',
          nilai: '92%',
          subjudul: 'Stabil',
          warnaLatar: const Color(0xFFF0FFF4),
        ),
        _buildKartuStat(
          ikon: Icons.history,
          warnaIkon: Colors.teal,
          label: 'VARIASI',
          nilai: '+/- 12',
          subjudul: 'Rendah',
        ),
      ],
    );
  }

  Widget _buildKartuStat({
    required IconData ikon,
    required Color warnaIkon,
    required String label,
    required String nilai,
    required String subjudul,
    Color? warnaLatar,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: warnaLatar ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(ikon, size: 14, color: warnaIkon),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 0.5)),
            ],
          ),
          Text(nilai, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
          Text(subjudul, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildRiwayatTerakhir() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Riwayat Terakhir', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            GestureDetector(
              onTap: () {},
              child: const Text('LIHAT SEMUA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2979FF), letterSpacing: 0.5)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._riwayat.map((r) => _buildItemRiwayat(r)),
      ],
    );
  }

  Widget _buildItemRiwayat(Map<String, dynamic> r) {
    final int nilai = r['nilai'];
    final Color warnaIkon = r['warna'];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: warnaIkon.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.water_drop, color: warnaIkon, size: 22),
        ),
        title: Text(
          '$nilai mg/dL',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
        subtitle: Text(
          '${r['waktu']} • ${r['keterangan']}',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[300]),
      ),
    );
  }
}

// Extension untuk capitalize string
extension StringExtension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}

// Widget custom grafik garis
class _GrafikGaris extends StatelessWidget {
  final List<double> data;
  final List<String> labelHari;
  final int indeksAktif;

  const _GrafikGaris({required this.data, required this.labelHari, required this.indeksAktif});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GrafisPainter(data: data, indeksAktif: indeksAktif),
      child: const SizedBox.expand(),
    );
  }
}

class _GrafisPainter extends CustomPainter {
  final List<double> data;
  final int indeksAktif;

  _GrafisPainter({required this.data, required this.indeksAktif});

  @override
  void paint(Canvas canvas, Size size) {
    final double nilaiMin = 60;
    final double nilaiMax = 180;
    final double rentang = nilaiMax - nilaiMin;
    final double padTop = 20;
    final double padBottom = 10;
    final double tinggiGrafik = size.height - padTop - padBottom;

    double toY(double val) {
      return padTop + tinggiGrafik * (1 - (val - nilaiMin) / rentang);
    }

    double toX(int i) {
      return i * size.width / (data.length - 1);
    }

    // Garis referensi
    final paintRef = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Garis Tinggi (180+)
    paintRef.color = Colors.red.withValues(alpha: 0.3);
    canvas.drawLine(Offset(0, toY(160)), Offset(size.width, toY(160)), paintRef);
    // Garis Normal (70-140)
    paintRef.color = Colors.grey.withValues(alpha: 0.25);
    canvas.drawLine(Offset(0, toY(120)), Offset(size.width, toY(120)), paintRef);
    // Garis Rendah
    paintRef.color = Colors.orange.withValues(alpha: 0.3);
    canvas.drawLine(Offset(0, toY(70)), Offset(size.width, toY(70)), paintRef);

    // Label garis referensi
    void drawLabel(String teks, double y, Color warna) {
      final tp = TextPainter(
        text: TextSpan(text: teks, style: TextStyle(fontSize: 9, color: warna)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width - tp.width - 2, y - 10));
    }
    drawLabel('Tinggi (180+)', toY(160), Colors.red.withValues(alpha: 0.5));
    drawLabel('Normal (70-140)', toY(120), Colors.grey.withValues(alpha: 0.5));
    drawLabel('Rendah (70-)', toY(70), Colors.orange.withValues(alpha: 0.5));

    // Buat path kurva halus
    final path = Path();
    final pathIsi = Path();

    for (int i = 0; i < data.length; i++) {
      final x = toX(i);
      final y = toY(data[i]);
      if (i == 0) {
        path.moveTo(x, y);
        pathIsi.moveTo(x, y);
      } else {
        final prevX = toX(i - 1);
        final prevY = toY(data[i - 1]);
        final cp1x = prevX + (x - prevX) / 2;
        final cp2x = prevX + (x - prevX) / 2;
        path.cubicTo(cp1x, prevY, cp2x, y, x, y);
        pathIsi.cubicTo(cp1x, prevY, cp2x, y, x, y);
      }
    }

    // Isi gradien di bawah kurva
    pathIsi.lineTo(toX(data.length - 1), size.height);
    pathIsi.lineTo(0, size.height);
    pathIsi.close();

    final gradienIsi = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF2979FF).withValues(alpha: 0.18), const Color(0xFF2979FF).withValues(alpha: 0.02)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(pathIsi, gradienIsi);

    // Garis kurva biru
    final paintGaris = Paint()
      ..color = const Color(0xFF2979FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paintGaris);

    // Titik aktif (KAM)
    final xAktif = toX(indeksAktif);
    final yAktif = toY(data[indeksAktif]);
    final paintTitikLuar = Paint()..color = Colors.white;
    final paintTitikDalam = Paint()..color = const Color(0xFF2979FF);
    canvas.drawCircle(Offset(xAktif, yAktif), 7, paintTitikLuar);
    canvas.drawCircle(Offset(xAktif, yAktif), 4.5, paintTitikDalam);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}