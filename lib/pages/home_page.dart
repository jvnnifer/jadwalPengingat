import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'input_field_jadwal.dart';
import 'input_field_pengingat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(activePage: 'home'),
      appBar: AppBar(
        title: Text('Beranda'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Jadwal Pelajaran',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Card(
                color: Colors.grey[200],
                elevation: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[100],
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.calendar_month,
                              size: 20,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Jadwal Pelajaran',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'lib/images/jadwal.png',
                      width: 250,
                      height: 250,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Wah, belum ada pelajaran!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Kamu bisa tambahkan pelajaran pada tombol dibawah ini.',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blue[100],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputFieldJadwal(),
                          ),
                        );
                      },
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.blue[700], size: 15),
                            Text(
                              'Tambah Jadwal',
                              style: TextStyle(
                                  color: Colors.blue[700], fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // Pengingat
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pengingat',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Card(
                color: Colors.grey[200],
                elevation: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[100],
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.timer,
                              size: 20,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Pengingat',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // Kolom yang berisi teks
                        Expanded(
                          flex:
                              2, // Menggunakan flex untuk mengatur proporsi ruang
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Rata kiri untuk teks
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Kamu belum mengisi pengingat.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  'Kamu bisa tambahkan pengingat pada tombol dibawah ini.',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.blue[100],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InputFieldPengingat(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add,
                                            color: Colors.blue[700], size: 15),
                                        SizedBox(
                                            width:
                                                5), // Memberikan sedikit jarak antara icon dan teks
                                        Text(
                                          'Buat Pengingat',
                                          style: TextStyle(
                                            color: Colors.blue[700],
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'lib/images/jam.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
