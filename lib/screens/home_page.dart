import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist_firebase/utils/styles.dart';
import 'package:todolist_firebase/widgets/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference? collection;
  List todos = [];
  String input = "";

  
  createTodos(String uid) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(input);

    Map<String, String> todoList = {"todoTitle": input, uid: uid};

    documentReference.set(todoList).whenComplete(() => {print("created")});
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference.delete().whenComplete(() => print("deleted"));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Styles.appColor,
          elevation: 0,
        ),
        drawer: drawer(context, user),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    title: const Text("Add Todolist"),
                    content: TextField(
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              createTodos(user.uid);
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Styles.appColor,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              )))
                    ],
                  );
                });
          },
          backgroundColor: Styles.appColor,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Styles.appColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/man.png",
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: const [
                          Text(
                            "8 Tasks",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text("Personal",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("MyTodos").snapshots(),
              builder: (context, AsyncSnapshot snapshots) {
                if (snapshots.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                  );
                } else if (snapshots.hasError) {
                  return const Text("Error occured!");
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshots.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot documentSnapshot =
                          snapshots.data.docs[index];
                      return Dismissible(
                        key: UniqueKey(),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            title: Text(documentSnapshot["todoTitle"]),
                            trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    // ignore: unnecessary_null_comparison
                                    deleteTodos((documentSnapshot != null)
                                        ? (documentSnapshot["todoTitle"])
                                        : "");
                                  });
                                },
                                icon: const Icon(Icons.delete)),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ));
  }
}
