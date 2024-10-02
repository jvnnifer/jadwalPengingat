import 'package:flutter/material.dart';

class InputFieldJadwal extends StatelessWidget {
  const InputFieldJadwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Judul',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
