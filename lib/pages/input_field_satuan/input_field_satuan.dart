import 'package:flutter/material.dart';

class InputFieldSatuan extends StatelessWidget {
  final String judul;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const InputFieldSatuan({
    Key? key,
    required this.judul,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      readOnly: widget == null ? false : true,
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  widget == null ? Container() : Container(child: widget),
                ],
              )),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
