import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_nosql/boxes/boxes.dart';
import 'package:hive_nosql/models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Hive Database')),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  _editDialogue(
                                      data[index],
                                      data[index].title.toString(),
                                      data[index].description.toString());
                                },
                                child: const Icon(Icons.edit)),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                delete(data[index]);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Text(data[index].description.toString()),
                      ],
                    ),
                  ),
                );
              },
            );
          }),

      // const SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       // FutureBuilder<Box>(
      //       //   future: Hive.openBox('bilal'),
      //       //   builder: (context, snapshot) {
      //       //     // Check if the snapshot has data and no errors
      //       //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       //       return const CircularProgressIndicator(); // Show loading indicator
      //       //     } else if (snapshot.hasError) {
      //       //       return Text('Error: ${snapshot.error}');
      //       //     } else if (!snapshot.hasData || snapshot.data == null) {
      //       //       return const Text('No data found');
      //       //     } else {
      //       //       var box = snapshot.data!;
      //       //       return Column(
      //       //         children: [
      //       //           ListTile(
      //       //             title: Text(box.get('name')?.toString() ?? 'No name'),
      //       //             subtitle: Text(box.get('age')?.toString() ?? 'No age'),
      //       //             trailing: IconButton(
      //       //               onPressed: () {
      //       //                 box.put('name', 'ch bilal');
      //       //                 setState(() {}); // Trigger UI update
      //       //               },
      //       //               icon: const Icon(Icons.edit),
      //       //             ),
      //       //           ),
      //       //         ],
      //       //       );
      //       //     }
      //       //   },
      //       // ),
      //       // FutureBuilder<Box>(
      //       //   future: Hive.openBox('bilal'),
      //       //   builder: (context, snapshot) {
      //       //     // Same checks for the second FutureBuilder
      //       //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       //       return const CircularProgressIndicator();
      //       //     } else if (snapshot.hasError) {
      //       //       return Text('Error: ${snapshot.error}');
      //       //     } else if (!snapshot.hasData || snapshot.data == null) {
      //       //       return const Text('No data found');
      //       //     } else {
      //       //       var box = snapshot.data!;
      //       //       return Column(
      //       //         children: [
      //       //           ListTile(
      //       //             title: Text(box.get('name')?.toString() ?? 'No name'),
      //       //             subtitle: Text(box.get('age')?.toString() ?? 'No age'),
      //       //             trailing: IconButton(
      //       //               onPressed: () {
      //       //                 box.delete('name'); // Delete the 'name' entry
      //       //                 setState(() {}); // Trigger UI update
      //       //               },
      //       //               icon: const Icon(Icons.delete),
      //       //             ),
      //       //           ),
      //       //         ],
      //       //       );
      //       //     }
      //       //   },
      //       // ),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDialogue();
          // var box = await Hive.openBox('bilal');
          // var box2 = await Hive.openBox('name');

          // // Storing data in Hive
          // box.put('name', 'bilal');
          // box.put('age', '25');
          // box.put('details', {'profession': 'developer', 'city': 'rwp'});

          // box2.put('youtube', 'Muhammad Bilal');

          // // Debug print statements
          // debugPrint(box.get('name'));
          // debugPrint(box.get('age'));

          // Map<String, String> details = box.get('details');
          // debugPrint(
          //     details.toString()); // Output: {profession: developer, city: rwp}
          // debugPrint(details['profession']); // Output: developer
          // debugPrint(details['city']); // Output: rwp

          // setState(() {}); // Update the UI after storing data
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialogue(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  notesModel.title = titleController.text.toString();
                  notesModel.description =
                      descriptionController.text.toString();

                  await notesModel.save();

                  titleController.clear();
                  descriptionController.clear();
                },
                child: const Text('Edit'),
              ),
            ],
          );
        });
  }

  Future<void> _showDialogue() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descriptionController.text);
                  final box = Boxes.getData();
                  box.add(data);
                  // data.save();
                  titleController.clear();
                  descriptionController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }
}
