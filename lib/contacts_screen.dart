import 'package:contacts/contact_model.dart';
import 'package:contacts/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ContactsScreen extends StatelessWidget {
  ContactsScreen({super.key});

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/telephone.png',
                  width: 40,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 25, 171, 144),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            color: Colors.white,
            onPressed: () => contactBottomSheet(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<HiveService>(builder: (context, hiveService, child) {
        if (hiveService.contacts.isNotEmpty) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.sort,
                    color: Color.fromARGB(251, 8, 28, 109),
                  ),
                  TextButton(
                    child: const Text(
                      'Sort by creation date',
                      style: TextStyle(
                        color: Color.fromARGB(251, 8, 28, 109),
                      ),
                    ),
                    onPressed: () => hiveService.sortContactsByCreationDate(),
                  ),
                  TextButton(
                    child: const Text(
                      'Sort by name',
                      style: TextStyle(
                        color: Color.fromARGB(251, 8, 28, 109),
                      ),
                    ),
                    onPressed: () => hiveService.sortContactsByName(),
                  ),
                ],
              ),
              const Divider(),
              ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                shrinkWrap: true,
                itemCount: hiveService.contacts.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(hiveService.contacts[index].firstName),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(hiveService.contacts[index].lastName ??
                                      ''),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(hiveService.contacts[index].mobileNumber),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  contactBottomSheet(
                                    context,
                                    edit: true,
                                    firstName:
                                        hiveService.contacts[index].firstName,
                                    lastName:
                                        hiveService.contacts[index].lastName ??
                                            '',
                                    mobileNumber: hiveService
                                        .contacts[index].mobileNumber,
                                    index: index,
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete Contact'),
                                        content: Text(
                                            'Are you sure you want to delete ${hiveService.contacts[index].firstName}?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 25, 171, 144),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              hiveService.removeItem(
                                                  hiveService.contacts[index]);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 25, 171, 144),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('You still have no contacts'),
                TextButton(
                  onPressed: () => contactBottomSheet(context),
                  child: const Text(
                    'Add New Contact',
                    style: TextStyle(
                      color: Color.fromARGB(255, 25, 171, 144),
                      decoration: TextDecoration.underline,
                      decorationColor: Color.fromARGB(255, 25, 171, 144),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Future<void> contactBottomSheet(BuildContext context,
      {String? firstName,
      String? lastName,
      String? mobileNumber,
      int? index,
      bool edit = false}) {
    firstNameController.text = firstName ?? '';
    lastNameController.text = lastName ?? '';
    mobileNumberController.text = mobileNumber ?? '';

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsetsDirectional.only(
                top: 20,
                start: 20,
                end: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(20),
                topEnd: Radius.circular(20),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 30),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 25, 171, 144),
                        ),
                        child: const Icon(
                          Icons.person_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            cursorColor:
                                const Color.fromARGB(255, 25, 171, 144),
                            controller: firstNameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 25, 171, 144),
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'First Name',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 25, 171, 144)),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (val) {
                              if (val?.isEmpty ?? false) {
                                return 'First Name can\'t\nbe empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            cursorColor:
                                const Color.fromARGB(255, 25, 171, 144),
                            controller: lastNameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 25, 171, 144),
                                    width: 2.0),
                              ),
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 25, 171, 144)),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        cursorColor: const Color.fromARGB(255, 25, 171, 144),
                        controller: mobileNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 25, 171, 144),
                                width: 2.0),
                          ),
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 25, 171, 144)),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          RegExp regExp = RegExp(r'^[0-9]{10}$');
                          if ((value?.isNotEmpty ?? false) &&
                              (!regExp.hasMatch(value ?? ''))) {
                            return 'Please enter a valid mobile number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Discard',
                            style: TextStyle(
                              color: Color.fromARGB(255, 53, 65, 63),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Consumer<HiveService>(
                            builder: (context, hiveService, child) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                edit
                                    ? hiveService.editContact(
                                        Contact(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            mobileNumber:
                                                mobileNumberController.text),
                                        index!)
                                    : hiveService.createItem(
                                        Contact(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            mobileNumber:
                                                mobileNumberController.text),
                                      );
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              edit ? 'Edit' : 'Add',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 25, 171, 144),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
