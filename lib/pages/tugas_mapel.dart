import 'package:flutter/material.dart';

class Tugas {
  int? id;
  String? judul;
  String? note;
  String? tanggal;
  String? waktuMulai;
  String? waktuSelesai;
  int? warna;
  tugasMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['judul'] = judul!;
    mapping['note'] = note!;
    mapping['tanggal'] = tanggal!;
    mapping['waktuMulai'] = waktuMulai!;
    mapping['waktuSelesai'] = waktuSelesai!;
    mapping['warna'] = warna;
    return mapping;
  }

  Color convertColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.pink;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class Mapel {
  int? id;
  String? judul;
  String? hari;
  String? pengajar;
  String? ruang;
  String? waktuMulai;
  String? waktuSelesai;
  int? warna;
  mapelMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['judul'] = judul!;
    mapping['hari'] = hari!;
    mapping['pengajar'] = pengajar!;
    mapping['ruang'] = ruang!;
    mapping['waktuMulai'] = waktuMulai!;
    mapping['waktuSelesai'] = waktuSelesai!;
    mapping['warna'] = warna;
    return mapping;
  }

  Color convertColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.pink;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
