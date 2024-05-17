import 'package:hive/hive.dart';
part 'contact_model.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  String firstName;
  @HiveField(1)
  String? lastName;
  @HiveField(2)
  String mobileNumber;
 
  Contact({ 
    required this.firstName,
     this.lastName,
    required this.mobileNumber,
  });
}