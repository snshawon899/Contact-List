import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final snController = TextEditingController();
  final CollectionReference _items =
      FirebaseFirestore.instance.collection("items");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
      ),
      body: StreamBuilder(
        stream: _items.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, ind) {
                  final DocumentSnapshot snapshot =
                      streamSnapshot.data!.docs[ind];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          snapshot["sn"].toString(),
                        ),
                        radius: 17,
                      ),
                      title: Text(
                        snapshot['name'],
                      ),
                      subtitle: Text(snapshot["number"].toString()),
                      trailing: SizedBox(
                        width: 40,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return updateDeleteData(snapshot);
                                });
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createData(),
        label: const Text("Add Contact"),
      ),
    );
  }

  Future<void> createData([DocumentSnapshot? snapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Create your Contact"),
                ),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "nm.Elon",
                  ),
                ),
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Contact",
                    hintText: "nm.10",
                  ),
                ),
                TextFormField(
                  controller: snController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "SN",
                    hintText: "nm.1",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text;
                    final int? sn = int.tryParse(snController.text);
                    final int? number = int.tryParse(contactController.text);
                    if (number != null) {
                      await _items
                          .add({"name": name, "number": number, "sn": sn});
                      nameController.text = '';
                      contactController.text = '';
                      snController.text = '';
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add Contact"),
                ),
              ],
            ),
          );
        });
  }

  Future<void> updateData([DocumentSnapshot? snapshot]) async {
    if (snapshot != null) {
      nameController.text = snapshot['name'];
      contactController.text = snapshot['number'].toString();
      snController.text = snapshot['sn'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Update Contact"),
                ),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "nm.Elon",
                  ),
                ),
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Contact",
                    hintText: "nm.10",
                  ),
                ),
                TextFormField(
                  controller: snController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "SN",
                    hintText: "nm.1",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text;
                    final int? sn = int.tryParse(snController.text);
                    final int? number = int.tryParse(contactController.text);
                    if (number != null) {
                      await _items
                          .doc(snapshot!.id)
                          .update({"name": name, "number": number, "sn": sn});
                      nameController.text = '';
                      contactController.text = '';
                      snController.text = '';
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Update Number"),
                ),
              ],
            ),
          );
        });
  }

  Future<void> deleteData(String contactId) async {
    await _items.doc(contactId).delete();
  }

  Widget updateDeleteData(DocumentSnapshot? snapshot) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                if (snapshot != null) {
                  updateData(snapshot);
                }
              },
              child: const Text("Edit")),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              if (snapshot != null) {
                deleteData(snapshot.id);
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
