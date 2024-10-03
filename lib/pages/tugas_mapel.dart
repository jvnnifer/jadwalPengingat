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
