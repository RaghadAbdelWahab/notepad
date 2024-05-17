import 'dart:collection';

import 'package:contacts/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService extends ChangeNotifier {
  List<Contact> _contacts = [];
  UnmodifiableListView<Contact> get contacts => UnmodifiableListView(_contacts);
  final String contactHiveBox = 'contact-box';
  bool isSortedByName = false;
  bool isSortedByCreationDate = false;

  sortContactsByCreationDate() async {
    Box<Contact> box = await Hive.openBox<Contact>(contactHiveBox);

    _contacts = box.values.toList()..sort((a, b) => a.key.compareTo(b.key));
    notifyListeners();
  }

  sortContactsByName() async {
    Box<Contact> box = await Hive.openBox<Contact>(contactHiveBox);
    _contacts = box.values.toList()
      ..sort((a, b) => a.firstName.compareTo(b.firstName));
    notifyListeners();
  }

  void editContact(Contact updatedContact, int index) async {
    Box<Contact> box = await Hive.openBox<Contact>(contactHiveBox);
    if (index != -1) {
      box.putAt(index, updatedContact);
      notifyListeners();
    }
  }

  Future<void> createItem(Contact contact) async {
    Box<Contact> box = await Hive.openBox<Contact>(contactHiveBox);
    await box.add(contact);
    _contacts.add(contact);
    _contacts = box.values.toList();
    notifyListeners();
  }

  Future<void> getItems() async {
    Box<Contact> box = await Hive.openBox<Contact>(contactHiveBox);
    _contacts = box.values.toList();
    notifyListeners();
  }

  Future<void> removeItem(Contact contact) async {
    Box<Contact> box = await Hive.openBox<Contact>(contactHiveBox);
    await box.delete(contact.key);
    _contacts = box.values.toList();
    notifyListeners();
  }
}
