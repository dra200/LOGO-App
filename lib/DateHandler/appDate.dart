import 'package:capcafe_app/Models/Addres.dart';
import 'package:flutter/cupertino.dart';



class appDate extends ChangeNotifier
{
  Addres pickUpLocation, dropOffLocation;
  void updatePickUpLocationAddress(Addres pickUpAddress)
  {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
  void updateDropOffLocationAddress(Addres dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

}