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
      'warna': warna,
    };
  }

  // Membuat objek Tugas dari JSON
  static Tugas fromJson(Map<String, dynamic> json) {
    return Tugas(
      judul: json['judul'],
      note: json['note'],
      tanggal: json['tanggal'],
      waktuMulai: json['waktuMulai'],
      waktuSelesai: json['waktuSelesai'],
      warna: json['warna'],
    );
  }
}

class Mapel {
  String judul;
  String hari;
  String pengajar;
  String ruang;
  String waktuMulai;
  String waktuSelesai;
  Color warna;

  Mapel({
    required this.judul,
    required this.hari,
    required this.pengajar,
    required this.ruang,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.warna,
  });
}
