import 'package:flutter/material.dart';

class Tugas {
  String judul;
  String note;
  String tanggal;
  String waktuMulai;
  String waktuSelesai;
  Color warna;

  Tugas({
    required this.judul,
    required this.note,
    required this.tanggal,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.warna,
  });

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'note': note,
      'tanggal': tanggal,
      'waktuMulai': waktuMulai,
      'waktuSelesai': waktuSelesai,
      'warna': warna.value,
    };
  }

  static Tugas fromJson(Map<String, dynamic> json) {
    return Tugas(
      judul: json['judul'],
      note: json['note'],
      tanggal: json['tanggal'],
      waktuMulai: json['waktuMulai'],
      waktuSelesai: json['waktuSelesai'],
      warna: Color(json['warna']),
    );
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
