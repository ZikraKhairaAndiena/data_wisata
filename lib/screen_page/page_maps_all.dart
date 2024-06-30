import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../model/model_wisata.dart';

class MapsWisataPage extends StatefulWidget {
  @override
  _MapsWisataPageState createState() => _MapsWisataPageState();
}

class _MapsWisataPageState extends State<MapsWisataPage> {
  late GoogleMapController mapController;
  Future<ModelWisata>? _wisataFuture;

  @override
  void initState() {
    super.initState();
    _wisataFuture = fetchWisata();
  }

  Future<ModelWisata> fetchWisata() async {
    final response = await http.get(Uri.parse('http://192.168.100.110/data_wisata/getWisata.php'));

    if (response.statusCode == 200) {
      return modelWisataFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Wisata'),
      ),
      body: FutureBuilder<ModelWisata>(
        future: _wisataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            Set<Marker> markers = snapshot.data!.data.map((wisata) {
              return Marker(
                markerId: MarkerId(wisata.nama),
                position: LatLng(double.parse(wisata.lat), double.parse(wisata.long)),
                infoWindow: InfoWindow(
                  title: wisata.nama,
                  snippet: wisata.lokasi,
                ),
              );
            }).toSet();

            return GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(-0.9145, 100.4607), // Center map coordinates
                zoom: 10,
              ),
              markers: markers,
            );
          }
        },
      ),
    );
  }
}
