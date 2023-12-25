import 'package:flutter/material.dart';

import '../model/contact_model.dart';
import '../service/http_service.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late Future<ContactModel> fetchContact;

  @override
  void initState() {
    super.initState();
    fetchContact = fetchContactDetails();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FutureBuilder<ContactModel>(
            future: fetchContact,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.data.length,
                  itemBuilder: (context, int index) {
                    var contact = snapshot.data?.data.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3.0, // Set the elevation as needed
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  radius: 35.0, // Set the desired radius
                                  backgroundImage: NetworkImage(contact!.avatar),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${contact.firstName} ${contact.lastName}"),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                          "0772534276",
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                          ),
                                      ),
                                      Text(
                                        contact.email,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          // Handle edit button press
                                        },
                                      ),
                                      // SizedBox(height: 4.0), // Adjust the height to reduce spacing
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          // Handle delete button press
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
