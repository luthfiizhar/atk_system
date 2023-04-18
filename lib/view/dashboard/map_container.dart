import 'package:atk_system_ga/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapContainer extends StatefulWidget {
  MapContainer({super.key});

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1100,
      height: 600,
      color: platinum,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          enableScrollWheel: false,
          enableMultiFingerGestureRace: false,
          onTap: (tapPosition, point) {},
          center: LatLng(-2.849646, 118.020644),
          zoom: 5,
          onMapEvent: (p0) {},
          // enableScrollWheel: false,
          // absorbPanEventsOnScrollables: false,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
            userAgentPackageName: 'com.klgsys.gss',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(-6.186391101422788, 106.73462621473294),
                builder: (context) => const Icon(
                  Icons.location_on,
                ),
              )
            ],
          )
          // PolygonLayer(polygons: [
          //   Polygon(
          //     points: notFilledPoints,
          //     isFilled: false, // By default it's false
          //     borderColor: Colors.red,
          //     borderStrokeWidth: 4,
          //   ),
          //   Polygon(
          //     points: filledPoints,
          //     isFilled: true,
          //     color: Colors.purple,
          //     borderColor: Colors.purple,
          //     borderStrokeWidth: 4,
          //   ),
          //   Polygon(
          //     points: notFilledDotedPoints,
          //     isFilled: false,
          //     isDotted: true,
          //     borderColor: Colors.green,
          //     borderStrokeWidth: 4,
          //     color: Colors.yellow,
          //   ),
          //   Polygon(
          //     points: filledDotedPoints,
          //     isFilled: true,
          //     isDotted: true,
          //     borderStrokeWidth: 4,
          //     borderColor: Colors.lightBlue,
          //     color: Colors.yellow,
          //   ),
          //   Polygon(
          //     points: labelPoints,
          //     borderStrokeWidth: 4,
          //     borderColor: Colors.purple,
          //     label: "Label!",
          //   ),
          //   Polygon(
          //     points: labelRotatedPoints,
          //     borderStrokeWidth: 4,
          //     borderColor: Colors.purple,
          //     label: "Rotated!",
          //     rotateLabel: true,
          //   ),
          //   Polygon(
          //     points: holeOuterPoints,
          //     //holePointsList: [],
          //     holePointsList: [holeInnerPoints],
          //     borderStrokeWidth: 4,
          //     borderColor: Colors.green,
          //     color: Colors.pink.withOpacity(0.5),
          //   ),
          // ])
        ],
      ),
    );
  }
}
