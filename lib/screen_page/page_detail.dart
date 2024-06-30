import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/model_wisata.dart';

class DetailWisata extends StatefulWidget {
  final Datum wisata;

  const DetailWisata({Key? key, required this.wisata}) : super(key: key);

  @override
  State<DetailWisata> createState() => _DetailWisataState();
}

class _DetailWisataState extends State<DetailWisata> {
  @override
  Widget build(BuildContext context) {
    final wisata = widget.wisata;

    double latitude = double.tryParse(wisata.lat) ?? 0.0;
    double longitude = double.tryParse(wisata.long) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(wisata.nama),
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'http://192.168.100.110/data_wisata/gambar/${wisata.gambar}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wisata.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text('Lokasi'),
                Text(
                  wisata.lokasi,
                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            trailing: const Icon(
              Icons.star,
              color: Colors.red,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              wisata.deskripsi,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Lokasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 16,
              ),
              mapType: MapType.normal,
              markers: {
                Marker(
                  markerId: MarkerId(wisata.nama),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(
                    title: wisata.nama,
                    snippet: wisata.lokasi,
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
