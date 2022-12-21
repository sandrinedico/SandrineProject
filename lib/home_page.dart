import 'dart:convert';
import 'package:flutter/material.dart';
import 'details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required Map edit}) : super(key: key);
  get edit => null;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> postData() async {

  }
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  List<Details> details = List.empty(growable: true);

  int count = 0;
  int selectedIndex = 0;

  bool isLoad = true;
  List items = <dynamic>[];

  //GET method
  Future<void> fetchData()async{
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(uri);
    final decodeValue = jsonDecode(response.body) as List;

    // ignore avoid_print
    print(response.statusCode);

    setState(() {
      var receivedFromApi = decodeValue;
      isLoad = false;
    });
    if(response.statusCode == 200){
      final json = convert.jsonDecode(response.body) as Map;
      final result= json['items'] as List;
      setState(() {
        items = result;
      });
    }
    else{
      return null;
    }
    setState(() {
      isLoad = false;
    });
  }

  Future <void> rouTing() async {
    var route = MaterialPageRoute(builder: (context)=>HomePage(edit: {},));
    await Navigator.push(context, route);

    setState(() {
      isLoad = true;
    });

    fetchData();
  }

  Future <void> editPage(Map item) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(edit: item)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Personal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'Ex: Sandrine Dico',
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  )
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Ex: 21 years old',
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  )
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.number,
              maxLength: 11,
              decoration: const InputDecoration(
                  hintText: 'Ex: 09873426111',
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  )
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'Ex: sandrinedico@gmail.com',
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  )
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: addressController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'Ex: Tambo Macasandig Cagayan de Oro City',
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  )
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {
                  String name = nameController.text.trim();
                  String age = ageController.text.trim();
                  String number = numberController.text.trim();
                  String email = emailController.text.trim();
                  String address = addressController.text.trim();
                  if (name.isNotEmpty && age.isNotEmpty && number.isNotEmpty &&
                      email.isNotEmpty && address.isNotEmpty) {
                    setState(() {
                      nameController.text = '';
                      ageController.text = '';
                      numberController.text = '';
                      emailController.text = '';
                      addressController.text = '';
                      details.add(Details(name: name,
                          age: age,
                          number: number,
                          email: email,
                          address: address));
                    });
                  }
                }, child: const Text('Save')),
                ElevatedButton(onPressed: () {
                  String name = nameController.text.trim();
                  String age = ageController.text.trim();
                  String number = numberController.text.trim();
                  String email = emailController.text.trim();
                  String address = addressController.text.trim();

                  if (name.isNotEmpty && age.isNotEmpty && number.isNotEmpty &&
                      email.isNotEmpty && address.isNotEmpty) {
                    setState(() {
                      nameController.text = '';
                      ageController.text = '';
                      numberController.text = '';
                      emailController.text = '';
                      addressController.text = '';
                      details[selectedIndex].name = name;
                      details[selectedIndex].age = age;
                      details[selectedIndex].number = number;
                      details[selectedIndex].email = email;
                      details[selectedIndex].address = address;
                      selectedIndex = 0;
                    });
                  }
                }, child: const Text('Update')),
              ],
            ),
            const SizedBox(height: 10),
            details.isEmpty ? const Text('Empty Details',
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),) :
            Expanded(
              child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) => getRow(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index % 2 == 0 ? Colors.black87 : Colors.amberAccent,
          child: Text(details[index].name[0]),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details[index].name),
            Text(details[index].age),
            Text(details[index].number),
            Text(details[index].email),
            Text(details[index].address),
          ],
        ),
        trailing: SizedBox(
          width: 60,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    nameController.text = details[index].name;
                    ageController.text = details[index].age;
                    numberController.text = details[index].number;
                    emailController.text = details[index].email;
                    addressController.text = details[index].address;

                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: const Icon(Icons.edit)),
              InkWell(
                  onTap: (() {
                    setState(() {
                      details.removeAt(index);
                    });
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
