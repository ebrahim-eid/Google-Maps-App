import 'package:flutter/material.dart';
import 'package:flutter_maps/feature/data/models/places_predictions_model.dart';
import 'package:flutter_maps/feature/presentation/controllers/maps_cubit/map_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/helpers/reusable_widgets.dart';

/// floating search
Widget buildFloatingSearchBar(context,List<LatLng> polyLinePoints) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  FloatingSearchBarController controller = FloatingSearchBarController();
  return FloatingSearchBar(
    hint: 'Search....',
    controller: controller,
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      MapCubit.get(context).getPlacesPredictions(
          placeName: query, sessionToken: const Uuid().v4());
    },
    progress:MapCubit.get(context).progressInd,
    onFocusChanged: (value){
     MapCubit.get(context).updateScreenStateToRemoveTimeDistanceLabels();
    },
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.place),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            if (MapCubit.get(context).predictList.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        MapCubit.get(context).placesModel =
                            MapCubit.get(context).predictList[index];
                        controller.close();
                        await MapCubit.get(context).getPlacesDetails(
                            placeId: MapCubit.get(context)
                                .predictList[index]
                                .placeId,
                            sessionToken: const Uuid().v4());
                        polyLinePoints.clear();
                        // MapCubit.get(context).clearMarkerState();
                      },
                      child: buildPredictionsList(
                          MapCubit.get(context).predictList[index])),
                  itemCount: MapCubit.get(context).predictList.length,
                ),
              ),
          ],
        ),
      );
    },
  );
}

/// build predictions list item
Widget buildPredictionsList(PlacesModel model) {
  var subTitle =
      model.description.replaceAll(model.description.split(',')[0], '');
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.lightBlueColor),
            child: const Icon(
              Icons.place,
              color: AppColors.blueColor,
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${model.description.split(',')[0]}\n',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: subTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        )),
  );
}

/// google map
Widget buildMap(context, mapController,List<LatLng> polyLinePoints) {

  return GoogleMap(
    mapType: MapType.normal,
    myLocationEnabled: true,
    markers: MapCubit.get(context).markers,
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    initialCameraPosition: MapCubit.get(context).cameraPosition!,
    onMapCreated: (GoogleMapController controller) {
      mapController.complete(controller);
    },
    polylines: MapCubit.get(context).directionModel !=null ?{
      Polyline(
          polylineId: const PolylineId('App-Id'),
        color: Colors.blue,
        width: 4,
        points: polyLinePoints)
    }:{},
  );
}

/// Side drawer
Widget sideDrawer(context) {
  // String email = AuthCubit.get(context).getLoggedInUser().email.toString();
  return Drawer(
    width: 320,
    child: ListView(
      children: [
        SizedBox(
          height: 300,
          child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[100]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              height: 250,
              color: Colors.blue[100],
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/image.png',
                    height: 150,
                    width: 300,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Ibrahim Eid',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                   Text(
                    'ebrahimeid1134@gmail.com',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
        buildListTitle(
            leadingIcon: Icons.place, title: 'Places History', onTap: () {}),
        const Divider(
          thickness: 2,
          endIndent: 25,
          indent: 25,
        ),

        buildListTitle(
            leadingIcon: Icons.logout,
            isTrailing: false,
            color: Colors.red,
            title: 'Logout',
            onTap: () async {
              await MapCubit.get(context).signOut();
            }),
        const Divider(
          thickness: 2,
          endIndent: 25,
          indent: 25,
        ),
      ],
    ),
  );
}


