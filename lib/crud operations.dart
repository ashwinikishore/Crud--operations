import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CrudPage()));
}

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  List<Map<String, dynamic>> dataList = [];
  int idCounter = 1;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  void showFormDialog({Map<String, dynamic>? item}) {
    if (item != null) {
      nameController.text = item['name'];
      jobController.text = item['job'];
      locationController.text = item['location'];
      mobileController.text = item['mobile'];
    } else {
      nameController.clear();
      jobController.clear();
      locationController.clear();
      mobileController.clear();
    }

    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text(item == null ? 'Add New Entry' : 'Edit Entry'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController,
                      decoration: InputDecoration(labelText: 'Name')),
                  TextField(controller: jobController,
                      decoration: InputDecoration(labelText: 'Job')),
                  TextField(controller: locationController,
                      decoration: InputDecoration(labelText: 'Location')),
                  TextField(
                    controller: mobileController,
                    decoration: InputDecoration(labelText: 'Mobile Number'),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (item == null) {
                    // Create
                    setState(() {
                      dataList.add({
                        'id': idCounter++,
                        'name': nameController.text,
                        'job': jobController.text,
                        'location': locationController.text,
                        'mobile': mobileController.text,
                      });
                    });
                  } else {

                    setState(() {
                      item['name'] = nameController.text;
                      item['job'] = jobController.text;
                      item['location'] = locationController.text;
                      item['mobile'] = mobileController.text;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(item == null ? 'Save' : 'Update'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              )
            ],
          ),
    );
  }

  void deleteItem(int id) {
    setState(() {
      dataList.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job description',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),)),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (_, index) {
          final item = dataList[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(item['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Job: ${item['job']}'),
                  Text('Location: ${item['location']}'),
                  Text('Mobile: ${item['mobile']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => showFormDialog(item: item),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteItem(item['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFormDialog(),
        child: Icon(Icons.add),
      ),

    );
  }
}