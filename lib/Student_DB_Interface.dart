import 'package:flutter/material.dart';
import 'package:second/API/DBHelper.dart';
import 'package:second/Model/Student.dart';

void main() {
  return runApp(MaterialApp(
    title: 'Dehello',
    theme: ThemeData(primarySwatch: Colors.deepPurple),
    home: StudentInterface(),
    debugShowCheckedModeBanner: false,
  ));
}

class StudentInterface extends StatefulWidget {
  @override
  _StudentInterfaceState createState() => _StudentInterfaceState();
}

class _StudentInterfaceState extends State<StudentInterface> {
  var txtstyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  TextEditingController id_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController major_controller = TextEditingController();
  TextEditingController mark_controller = TextEditingController();
  List<Map<String, dynamic>> mapData = [];
  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Student Database'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                txtField('ID', id_controller),
                SizedBox(height: 10,),
                txtField('Name', name_controller),
                SizedBox(height: 10,),
                txtField('Major', major_controller),
                SizedBox(height: 10,),
                txtField('Mark', mark_controller),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: ElevatedButton(
                            onPressed: () async {
                              Student s = Student(
                                  int.parse(id_controller.text),
                                  int.parse(mark_controller.text),
                                  name_controller.text,
                                  major_controller.text);
                              await dbHelper.insertStudent(s);
                              mapData = await dbHelper.getAllStudents();
                              setState(() {

                              });
                            },
                            child: Text('Insert Student')),),
                        SizedBox(width: 10,),
                        Expanded(child: ElevatedButton(
                            onPressed: () async {
                              Student s = Student(
                                  int.parse(id_controller.text),
                                  int.parse(mark_controller.text),
                                  name_controller.text,
                                  major_controller.text);
                              dbHelper.updateStudent(s);
                              mapData = await dbHelper.getAllStudents();

                              setState(() {});
                            },
                            child: Text('Update Student')),),
                        SizedBox(width: 10,),

                      ],
                    ),

                Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                       Expanded(child: ElevatedButton(
                     onPressed: () async{
                       int id = int.parse(id_controller.text);
                       dbHelper.deleteStudent(id);
                       mapData = await dbHelper.getAllStudents();
                       setState(() {

                       });
                     },
                     child: Text('Delete Student'),),),
                       SizedBox(width: 10,),
                       Expanded(child: ElevatedButton(
                       onPressed: () {
                         id_controller.text = ' ';
                         mark_controller.text = ' ';
                         major_controller.text = ' ';
                         name_controller.text = ' ';
                         setState(() {});
                       },
                       child: Text('Clear'))),
                       SizedBox(width: 10,),

                 ],
               ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: ElevatedButton(
                        onPressed: () async {
                          int id = int.parse(id_controller.text);
                          mapData = await dbHelper.getByID(id);
                          setState(() {
                          });
                        },
                        child: Text('Get By ID'))),
                    SizedBox(width: 10,),
                    Expanded(child: ElevatedButton(
                      onPressed: () async{
                        mapData = await dbHelper.ifCSandMarkOver80();
                        setState(() {

                        });
                      },
                      child: Text('major CS &'
                          ' mark > 80'),),),
                    SizedBox(width: 10,),
                    Expanded(child: ElevatedButton(
                        onPressed: () async {
                          mapData = await dbHelper.getAllStudents();
                          setState(() {
                          });
                        },
                        child: Text('Get all')
                    )),
                  ],
                ),
              ],
            ),
          ),

          Container(
            height: 210,
            child: ListView.builder(itemCount: mapData.length,itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(5),
                elevation: 5,
                shadowColor: Colors.deepPurpleAccent,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(
                      mapData[index]['id'].toString(),
                      style: txtstyle,
                    ),
                  ),

                  trailing: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(
                      mapData[index]['mark'].toString(),
                      style: txtstyle,
                    ),
                  ),

                  title: Text(mapData[index]['name'],),

                  subtitle: Text(mapData[index]['major'],),

                  onTap: () {
                    id_controller.text =  mapData[index]['id'].toString();
                    name_controller.text = mapData[index]['name'].toString();
                    major_controller.text = mapData[index]['major'].toString();
                    mark_controller.text = mapData[index]['mark'].toString();
                    setState(() {

                    });
                  },
                ),
              );
            },)
          ),
        ],
      ),
    );
  }

  InputDecoration txtFieldDecoration(String title) {
    return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
        labelText: title);
  }

  Widget txtField (String decorationTitle, TextEditingController txtcontroller){
    return TextField(
      decoration: txtFieldDecoration(decorationTitle),
      controller: txtcontroller,
    );

  }

  Widget test (){
    return Text(mapData[0]['id'].toString());
  }
}