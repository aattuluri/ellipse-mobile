import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

const String homeTabEventsSearch = 'homeTabEventsSearch';
const String homeTabPostEvent = 'homeTabPostEvent';
const String homeTabEventsFilter = 'homeTabEventsFilter';
const String infoPageSliderMenu = 'infoPageSliderMenu';
const String profileTabSettings = 'profileTabSettings';
Widget featureDiscoveryOverlay(BuildContext context,
    {String featureId,
    Widget child,
    Widget tapTarget,
    ContentLocation contentLocation,
    String title,
    String description}) {
  return DescribedFeatureOverlay(
      featureId: featureId,
      tapTarget: tapTarget,
      title: Text(title),
      contentLocation: contentLocation,
      backgroundColor: Color(0xFF00BDAA).withOpacity(0.7),
      overflowMode: OverflowMode.clipContent,
      targetColor: Theme.of(context).cardColor.withOpacity(0.6),
      textColor: Theme.of(context).textTheme.caption.color,
      onDismiss: () {
        return Future.value(true);
      },
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(description),
          FlatButton(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            padding: EdgeInsets.zero,
            child: Text('Understood',
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color)),
            onPressed: () async =>
                FeatureDiscovery.completeCurrentStep(context),
          ),
          FlatButton(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            padding: EdgeInsets.zero,
            child: Text('Dismiss',
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color)),
            onPressed: () => FeatureDiscovery.dismissAll(context),
          ),
        ],
      ),
      child: child);
}
/*DescribedFeatureOverlay(
                              featureId:
                                  homeTabEventsFilter, // Unique id that identifies this overlay.
                              contentLocation: ContentLocation.above,
                              tapTarget: const Icon(Icons
                                  .search), // The widget that will be displayed as the tap target.
                              title: Text('Search Events'),
                              description: Text('Search events ny name'),
                              backgroundColor: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.8),
                              targetColor:
                                  Theme.of(context).cardColor.withOpacity(0.8),
                              textColor:
                                  Theme.of(context).textTheme.caption.color,
                              enablePulsingAnimation: true,
                              onComplete: () async {
                                return true;
                              },
                              child: IconButton(
                                tooltip: 'Search',
                                splashRadius: 20,
                                icon: Icon(Icons.search),
                                onPressed: () async {},
                              ),
                            ),*/
