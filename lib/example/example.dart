import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/core/local_storage/currectlocation.dart';

class current_location extends StatefulWidget {
  const current_location({super.key});

  @override
  State<current_location> createState() => _current_locationState();
}

class _current_locationState extends State<current_location> {
 String locationText="Getting Location";
 @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  mycurrentlocatio() async {
   bool serviceEnabled;
   LocationPermission permission;
   serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if(!serviceEnabled){
     setState(() {
       locationText='location permission are denied';
     });
     return;
   }
   permission = await Geolocator.checkPermission();
   if(permission == LocationPermission.deniedForever){
     setState(() {
       locationText='location permission are denied';
     });
     return;

   }

if(permission==LocationPermission.deniedForever){
  setState(() {
    locationText='location permission are permanently denied. please enable them in settings';
  });
  return;

}
Position positioned= await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
) ;

List<Placemark>placemark =await placemarkFromCoordinates(positioned.latitude, positioned.longitude);
Placemark place =placemark.first;
setState(() {
  print("User current location is ${place.locality}");
  locationText =
  "${place.locality}, ${place.administrativeArea}, ${place.country}";

});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Center(
  child:Text(
    locationText
  ),
),
    );
  }
}
