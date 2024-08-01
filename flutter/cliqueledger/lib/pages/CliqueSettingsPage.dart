import 'package:cliqueledger/api_helpers/fetchMemeber.dart';
import 'package:cliqueledger/models/member.dart';
import 'package:cliqueledger/providers/cliqueProvider.dart';
import 'package:cliqueledger/providers/userProvider.dart';
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Member> memberList = [
     Member(name: "Ant"),
      Member(name: "Seo Ri"),
      Member(name: "Ko Mun Young"),
      Member(name: "Seo Yeo Ji"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
      Member(name: "Tian Tian"),
    ];
  bool isEditing = false;
  TextEditingController _nameController =
      TextEditingController(text: "Example Name");
  @override
  Widget build(BuildContext context) {
    final clique = context.read<CliqueProvider>().currentClique;
    return Scaffold(
      appBar: GradientAppBar(title: "Clque Ledger"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  height:
                      120, // Slightly larger than the image to accommodate the border
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF145374), width: 2.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        75), // Half of the image height/width
                    child: Image.asset(
                      "assets/images/defaultCliqueLogo.png",
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding:
                          EdgeInsets.all(8.0), // Padding inside the nameplate
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded corners
                        border: Border.all(
                            color: Color(0xFF145374),
                            width: 1.0), // Border color and width
                        color:
                            Colors.white, // Background color of the nameplate
                      ),
                      child: isEditing
                          ? TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            )
                          : Text(
                                _nameController.text, // Replace with your dynamic name
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF145374), // Text color
                              ),
                            ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Color(0xFF145374)),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
                ],
              ),
              isEditing ?
              ElevatedButton(
                onPressed: (){
                  setState(() {
                        isEditing = false;
                      });
                },
                child: Text("Save")
              ) :
              SizedBox(height: 1,),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Participants",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed:(){},
                      child: Text("Add")
                    )
                  ],
                ),  
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: memberList.length,
                itemBuilder: (context, index) {
                  final member = memberList[index];
                  return ListTile(
                    title: Text(member.name),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
