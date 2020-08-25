import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapHeader extends StatelessWidget {
  static const double _markerSize = 40.0;
  final LatLng point;

  const MapHeader(this.point);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: point,
        zoom: 6,
        minZoom: 2,
        maxZoom: 15,
      ),
      layers: <LayerOptions>[
        TileLayerOptions(
          urlTemplate: Theme.of(context).brightness == Brightness.light
              ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}@2x.png?api_key=0a781f97-5aed-4ac9-bcb9-e15c13d65806'
              : 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}@2x.png?api_key=0a781f97-5aed-4ac9-bcb9-e15c13d65806',
          subdomains: ['a', 'b', 'c', 'd'],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        MarkerLayerOptions(markers: <Marker>[
          Marker(
            width: _markerSize,
            height: _markerSize,
            point: point,
            builder: (context) => Icon(
              Icons.location_on,
              color: Theme.of(context).accentColor,
              size: _markerSize,
            ),
          )
        ])
      ],
    );
  }
}
