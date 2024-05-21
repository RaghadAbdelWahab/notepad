import 'dart:collection';

import 'package:contacts/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService extends ChangeNotifier {
  List<Contact> _contacts = [];
  UnmodifiableListView<Contact> get contacts => UnmodifiableListView(_contacts);
  bool isSortedByName = false;
  bool isSortedByCreationDate = false;

  Box<Contact> ragadBox = Hive.box<Contact>('contact-box');

  sortContactsByCreationDate() async {
    _contacts = ragadBox.values.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    notifyListeners();
  }

  sortContactsByName() async {
    _contacts = ragadBox.values.toList()
      ..sort((a, b) => a.firstName.compareTo(b.firstName));
    notifyListeners();
  }

  void editContact(Contact updatedContact, int index) async {
    ragadBox.putAt(index, updatedContact);
    getItems();
  }

  Future<void> createItem(Contact contact) async {
    await ragadBox.add(contact);
    getItems();
  }

  Future<void> getItems() async {
    _contacts = ragadBox.values.toList();
    notifyListeners();
  }

  Future<void> removeItem(Contact contact) async {
    await ragadBox.delete(contact.key);
    getItems();
  }
}
