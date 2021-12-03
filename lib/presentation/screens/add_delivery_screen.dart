import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toot/constants.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/presentation/widgets/default_indigo_button.dart';

import 'delivery_screen.dart';

class AddDeliveryScreen extends StatefulWidget {
  int id;
  AddDeliveryScreen(this.id);

  @override
  State<AddDeliveryScreen> createState() => _AddDeliveryScreenState();
}

class _AddDeliveryScreenState extends State<AddDeliveryScreen> {
  TextEditingController address = TextEditingController();
  TextEditingController district = TextEditingController();
  GoogleMapController? mapController;
  bool markerTapped = false;
  final _formKey = GlobalKey<FormState>();
  Marker? marker;
  double? lat;
  double? lng;
  Position? currentLocation;
  getLocationStatus() async {
    var status = await Geolocator.isLocationServiceEnabled();
    if (status) {
      setState(() {
        // هفعل السيركل عشان الفيو وهى هتطفى تانى من تحت وهقول ان فى صيدليات بعد ماكان الموقع مش متفعل
        getUserLocation();
      });
    } else {
      setState(() {
        _showDialog(context);
      });
    }
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "الموقع",
            style: TextStyle(color: Colors.indigo),
          ),
          content: new Text(
              "لكى تتمكن من مشاهدة المطاعم بالقرب منك الرجاء تفعيل الموقع"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text(
                  "تفعيل",
                  style: TextStyle(color: Colors.indigo),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setActiveLocation();
                }),
            new FlatButton(
              child: new Text(
                "الغاء",
                style: TextStyle(color: Colors.indigo),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  setActiveLocation() async {
    var platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      AppSettings.openAppSettings();
    } else {
      final AndroidIntent intent = new AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch();
    }
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      markerTapped = true;
      marker =
          createMarker(currentLocation!.latitude, currentLocation!.longitude);
      lat = currentLocation!.latitude;
      lng = currentLocation!.longitude;
    });
    print(lat.toString() + 'ggg');
  }

  Future<Position> locateUser() {
    return Geolocator.getCurrentPosition();
  }

  Marker createMarker(double latitude, double longitude) {
    return Marker(
      draggable: true,
      markerId: MarkerId('Marker'),
      position: LatLng(latitude, longitude),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'اضافة عنوان',
            style: TextStyle(
                color: Color(Constants.mainColor), fontWeight: FontWeight.w300),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              size: 25,
              color: Color(Constants.mainColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey.shade50,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.05.sh),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العنوان',
                  style: TextStyle(
                      color: Color(Constants.mainColor), fontSize: 16.sp),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: address,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Color(Constants.mainColor), width: 0.8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Color(Constants.mainColor), width: 0.8),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Text(
                  'وصف مكان المنزل',
                  style: TextStyle(
                      color: Color(Constants.mainColor), fontSize: 16.sp),
                ),
                TextField(
                  maxLines: 3,
                  controller: district,
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Color(Constants.mainColor), width: 0.8)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Color(Constants.mainColor), width: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                markerTapped
                    ? Container(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: GoogleMap(
                            mapType: MapType.terrain,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(
                                  () => PanGestureRecognizer())),
                            onTap: (location) {
                              setState(() {
                                marker = createMarker(
                                    location.latitude, location.longitude);
                                lat = location.latitude;
                                lng = location.longitude;
                              });
                              print(lat);
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation!.latitude,
                                  currentLocation!.longitude),
                              zoom: 14.0,
                            ),
                            markers: Set<Marker>.of(
                              <Marker>[marker!],
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 40),
                Center(
                  child: BuildIndigoButton(
                      title: 'اضافة',
                      function: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<CartCubit>(context)
                              .addAddress(
                                  address: address.text,
                                  district: district.text,
                                  lat: lat,
                                  long: lng)
                              .then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryAddressesScreen(
                                          id: widget.id,
                                          added: true,
                                        )));
                          });
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
