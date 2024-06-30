import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pre/screen_page/page_detail.dart';
import '../model/model_wisata.dart';

class WisataScreen extends StatefulWidget {
  @override
  _WisataScreenState createState() => _WisataScreenState();
}

class _WisataScreenState extends State<WisataScreen> {
  late Future<ModelWisata> futureWisata;

  @override
  void initState() {
    super.initState();
    futureWisata = fetchWisata();
  }

  Future<ModelWisata> fetchWisata() async {
    final response = await http.get(Uri.parse('http://192.168.100.110/data_wisata/getWisata.php'));

    if (response.statusCode == 200) {
      return modelWisataFromJson(response.body);
    } else {
      throw Exception('Failed to load wisata');
    }
  }

  Future<void> deleteWisata(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.100.110/data_wisata/deleteWisata.php'),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      setState(() {
        futureWisata = fetchWisata();
      });
      Fluttertoast.showToast(msg: 'Wisata deleted');
    } else {
      Fluttertoast.showToast(msg: 'Failed to delete wisata');
    }
  }

  void _showUpdateDialog(Datum wisata) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController namaController = TextEditingController(text: wisata.nama);
    final TextEditingController lokasiController = TextEditingController(text: wisata.lokasi);
    final TextEditingController deskripsiController = TextEditingController(text: wisata.deskripsi);
    final TextEditingController latController = TextEditingController(text: wisata.lat);
    final TextEditingController longController = TextEditingController(text: wisata.long);
    final TextEditingController profileController = TextEditingController(text: wisata.profile);
    final TextEditingController gambarController = TextEditingController(text: wisata.gambar);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Wisata'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lokasiController,
                    decoration: InputDecoration(labelText: 'Lokasi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: deskripsiController,
                    decoration: InputDecoration(labelText: 'Deskripsi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: latController,
                    decoration: InputDecoration(labelText: 'Latitude'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter latitude';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: longController,
                    decoration: InputDecoration(labelText: 'Longitude'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter longitude';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: profileController,
                    decoration: InputDecoration(labelText: 'Profile'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a profile';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: gambarController,
                    decoration: InputDecoration(labelText: 'Gambar URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a gambar URL';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  updateWisata(
                    wisata.id,
                    namaController.text,
                    lokasiController.text,
                    deskripsiController.text,
                    latController.text,
                    longController.text,
                    profileController.text,
                    gambarController.text,
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void updateWisata(String id, String nama, String lokasi, String deskripsi, String lat, String long, String profile, String gambar) async {
    final response = await http.post(
      Uri.parse('http://192.168.100.110/data_wisata/updateWisata.php'),
      body: {
        'id': id,
        'nama': nama,
        'lokasi': lokasi,
        'deskripsi': deskripsi,
        'lat': lat,
        'long': long,
        'profile': profile,
        'gambar': gambar,
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Wisata updated');
      setState(() {
        futureWisata = fetchWisata(); // Refresh data after update
      });
    } else {
      print('Error: ${response.body}');
      Fluttertoast.showToast(msg: 'Failed to update wisata');
    }
  }


  void _showAddDialog() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController namaController = TextEditingController();
    final TextEditingController lokasiController = TextEditingController();
    final TextEditingController deskripsiController = TextEditingController();
    final TextEditingController latController = TextEditingController();
    final TextEditingController longController = TextEditingController();
    final TextEditingController profileController = TextEditingController();
    final TextEditingController gambarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Wisata'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lokasiController,
                    decoration: InputDecoration(labelText: 'Lokasi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: deskripsiController,
                    decoration: InputDecoration(labelText: 'Deskripsi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: latController,
                    decoration: InputDecoration(labelText: 'Latitude'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter latitude';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: longController,
                    decoration: InputDecoration(labelText: 'Longitude'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter longitude';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: profileController,
                    decoration: InputDecoration(labelText: 'Profile'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a profile';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: gambarController,
                    decoration: InputDecoration(labelText: 'Gambar URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a gambar URL';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  addWisata(
                    namaController.text,
                    lokasiController.text,
                    deskripsiController.text,
                    latController.text,
                    longController.text,
                    profileController.text,
                    gambarController.text,
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addWisata(String nama, String lokasi, String deskripsi, String lat, String long, String profile, String gambar) async {
    final response = await http.post(
      Uri.parse('http://192.168.100.110/data_wisata/addWisata.php'),
      body: {
        'nama': nama,
        'lokasi': lokasi,
        'deskripsi': deskripsi,
        'lat': lat,
        'long': long,
        'profile': profile,
        'gambar': gambar,
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Wisata added');

      setState(() {
        futureWisata = fetchWisata(); // Refresh data after add
      });
    } else {
      print('Error: ${response.body}');
      Fluttertoast.showToast(msg: 'Failed to add wisata');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wisata'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: FutureBuilder<ModelWisata>(
        future: futureWisata,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load wisata'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                return WisataCard(
                  wisata: snapshot.data!.data[index],
                  onDelete: () => deleteWisata(snapshot.data!.data[index].id),
                  onUpdate: () => _showUpdateDialog(snapshot.data!.data[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailWisata(wisata: snapshot.data!.data[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class WisataCard extends StatelessWidget {
  final Datum wisata;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback onTap;

  WisataCard({
    required this.wisata,
    required this.onDelete,
    required this.onUpdate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          'http://192.168.100.110/data_wisata/gambar/${wisata.gambar}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          wisata.nama,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          wisata.lokasi,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onUpdate,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
