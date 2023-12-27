// ignore_for_file: use_build_context_synchronously

import '../model/db_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  void _refreshData() async{
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  void _refreshSearchData(searchQuery) async{
    final data = await SQLHelper.searchData(searchQuery);
    if (data.isNotEmpty) {
      setState(() {
        _allData = data;
        _isLoading = false;
      });
    }else{
      final data = await SQLHelper.getAllData();
      setState(() {
        _allData = data;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("No match found"),
      ));
    }
  }

  @override
  void initState(){
    super.initState();
    _refreshData();
  }

  Future<void> _addData() async{
    String name = _nameController.text;
    String telephone = _telephoneController.text;
    // print(name);
    // print(telephone);

    if (name.isNotEmpty && telephone.isNotEmpty) {

      await SQLHelper.createData( name, telephone);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Data Added"),
      ));

      _refreshData();

    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Invalid Inputs"),
      ));
    }

  }

  Future<void> _searchData() async{
    String searchQuery = _searchController.text.trim();
      if (searchQuery.isNotEmpty) {
        // print(searchQuery);
        _refreshSearchData(searchQuery);

      }else{

        final data = await SQLHelper.getAllData();
        setState(() {
          _allData = data;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please enter a search key"),
        ));
      }
  }

  Future<void> _updateData(int id) async{

    String name = _nameController.text;
    String telephone = _telephoneController.text;

    // print(id);
    // print(_nameController.text);
    // print(_telephoneController.text);

    if (name.isNotEmpty && telephone.isNotEmpty) {
      await SQLHelper.updateData(id, name, telephone);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Data Updated"),
      ));

      _refreshData();
    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Invalid Inputs"),
      ));
    }
  }

  Future<void> _deleteData(int id) async{
    await SQLHelper.deleteData(id);

    ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Data Deleted"),
    ));

    _refreshData();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  void showBottomSheet(int? id) async {
    if(id != null){
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _nameController.text = existingData['name'] ?? '';
      _telephoneController.text = existingData['telephone'] ?? '';
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _telephoneController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Telephone",
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async{
                  if(id == null){
                    await _addData();
                  }if(id != null){
                    await _updateData(id);
                  }

                  _nameController.text = "";
                  _telephoneController.text = "";

                  Navigator.of(context).pop();
                  // print("Contact Added");
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Add Contact" : "Contact Update",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Enter search key",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
                await _searchData();
                _searchController.text = "";
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text("Search"),
            ),
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFECEAF4),
      appBar: AppBar(
        title: const Text("Contact Buddy"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchBottomSheet(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    subtitle: Text(_allData[index]['telephone'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              showBottomSheet(_allData[index]['id']);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.indigo,
                            )
                        ),
                        IconButton(
                            onPressed: () {
                              _deleteData(_allData[index]['id']);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            )
                        ),
                      ],
                    ),
                  ),
                ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}