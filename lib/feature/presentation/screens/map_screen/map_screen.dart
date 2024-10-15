import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/core/constants/app_colors.dart';
import 'package:flutter_maps/feature/presentation/controllers/maps_cubit/map_cubit.dart';
import 'package:flutter_maps/feature/presentation/controllers/maps_cubit/map_states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/helpers/cashe_helper/shared_prefernce.dart';
import '../../../../core/helpers/helper_fuctions/helper_functions.dart';
import '../../widgets/map_widgets/map_widgets.dart';
import '../../widgets/map_widgets/time_distance_widget.dart';
import '../login_screen/login_screen.dart';

// ignore: must_be_immutable
class MapScreen extends StatelessWidget {
  MapScreen({super.key});
  Completer<GoogleMapController> mapController = Completer();

  late Marker searchPlaceMarker;
  late Marker currentPlaceMarker;
  CameraPosition? newCameraPosition;
  List<LatLng> polyLinePoints = [];

  void buildNewCameraPosition(context) {
    if (MapCubit.get(context).placeDetailsModel != null) {
      newCameraPosition = CameraPosition(
        target: LatLng(
          MapCubit.get(context).placeDetailsModel!.lat,
          MapCubit.get(context).placeDetailsModel!.lng,
        ),
        tilt: 0.0,
        bearing: 0.0,
        zoom: 14,
      );
    }
  }

  /// go for the searched location
  Future<void> goToSearchedLocation(context) async {
    buildNewCameraPosition(context);
    if (newCameraPosition != null) {
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition!));
      buildSearchedPlaceMarker(context);
    }
  }

  /// searched marker
  void buildSearchedPlaceMarker(context) {
    if (newCameraPosition != null) {
      searchPlaceMarker = Marker(
        markerId: const MarkerId('1'),
        onTap: () {
          buildCurrentPlaceMarker(context);
          MapCubit.get(context).updateScreenStateToShowTimeDistanceLabels();
        },
        position: newCameraPosition!.target,
        infoWindow: InfoWindow(
          title: MapCubit.get(context).placesModel?.description ?? 'No description',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      MapCubit.get(context).addMarkers(searchPlaceMarker);
    }
  }

  /// current marker
  void buildCurrentPlaceMarker(context) {
    if (newCameraPosition != null) {
      currentPlaceMarker = Marker(
        markerId: const MarkerId('2'),
        position: newCameraPosition!.target,
        infoWindow: const InfoWindow(
          title: 'The current location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      MapCubit.get(context).addMarkers(currentPlaceMarker);
    }
  }

  /// poly lines points
  void getPolyLinesPoints(context) {
    polyLinePoints = MapCubit.get(context).polyLinesPoints.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapStates>(
      listener: (context, state) {

        if(state is SignOutState){
          CashHelper.setData(key: 'login', value: false).then((value){
            HelperFunctions.navigateAndReplace(context, LoginScreen());
          });
        }

        if (state is PlacesDetailsSuccessState) {
          goToSearchedLocation(context);
          MapCubit.get(context).getPlacesDirection(
            origin: LatLng(
              MapCubit.get(context).position!.latitude,
              MapCubit.get(context).position!.longitude,
            ),
            destination: LatLng(
              MapCubit.get(context).placeDetailsModel!.lat,
              MapCubit.get(context).placeDetailsModel!.lng,
            ),
          );
        }
        if (state is PlacesDirectionsSuccessState) {
          getPolyLinesPoints(context);
        }
      },
      builder: (context, state) {
        var cubit = MapCubit.get(context);
        Future<void> goToTheLake() async {
          final GoogleMapController controller = await mapController.future;
          if (cubit.cameraPosition != null) {
            controller.animateCamera(CameraUpdate.newCameraPosition(cubit.cameraPosition!));
          }
        }

        return SafeArea(
          child: Scaffold(
            drawer: sideDrawer(context),
            body: Stack(
              children: [
                if (cubit.cameraPosition != null)
                  buildMap(context, mapController, polyLinePoints)
                else
                  const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        color: AppColors.blueColor,
                      ),
                    ),
                  ),
                buildFloatingSearchBar(context, polyLinePoints),
                if (cubit.isSearchedPlaceMarkerClicked && cubit.directionModel != null)
                  DistanceAndTime(
                    isTimeAndDistanceVisible: cubit.isTimeDistanceVisible,
                    placeDirections: cubit.directionModel!,
                  ),
              ],
            ),
            floatingActionButton: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
              child: FloatingActionButton(
                backgroundColor: AppColors.blueColor,
                onPressed: goToTheLake,
                child: const Icon(
                  Icons.place,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

