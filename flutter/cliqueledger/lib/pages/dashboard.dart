import 'package:cliqueledger/api_helpers/createCliquePost.dart';
import 'package:cliqueledger/api_helpers/fetchCliqeue.dart';
import 'package:cliqueledger/models/cliqeue.dart';
import 'package:cliqueledger/models/cliquePostSchema.dart';
import 'package:cliqueledger/providers/cliqueProvider.dart';
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:cliqueledger/utility/routers_constant.dart';
import 'package:flutter/material.dart';
import 'package:cliqueledger/service/authservice.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CreateCliquePost createCliquePost = CreateCliquePost();
  final CliqueList cliqueList = CliqueList();
  bool isCliquesLoading = true;
  @override
  void initState() {
    super.initState();
    fetchCliques();
    //fetchFinishLedger();
  }
  Future<void> fetchCliques() async {
    await cliqueList.fetchData();
    setState(() {
      isCliquesLoading = false;
    });
  }



  void _createClique(BuildContext context) {
    // Navigate to create page or show a dialog
    // For demonstration, we'll show a simple dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool withFunds = false;
        final TextEditingController amountController = TextEditingController();
        final TextEditingController cliqueNameController = TextEditingController();
        final TextEditingController MembersController = TextEditingController();
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Create Clique'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: cliqueNameController,
                      decoration:
                          const InputDecoration(
                            hintText: "Enter Clique Name",),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Clique Name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: MembersController,
                      decoration:  const InputDecoration(hintText: "eg: john,bob12,alice03"),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "This field cannot be empty";
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: withFunds,
                          onChanged: (bool? value) {
                            setState(() {
                              withFunds = value ?? false;
                            });
                          },
                        ),
                        const Text("With funds"),
                      ],
                    ),
                    if (withFunds)
                      TextFormField(
                        controller: amountController,
                        decoration:
                            const InputDecoration(hintText: "Enter Amount"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Amount cannot be empty";
                          }
                          return null;
                        },
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Create'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Handle the create action
                      String amount = amountController.text;
                      String cliqueName = cliqueNameController.text;
                      String members = MembersController.text;
                      bool isActive = true;
                      List<String> membersList = members.split(',');
                      CliquePostSchema cls = amount.isEmpty
                      ? CliquePostSchema(name: cliqueName, members: membersList, isActive: isActive)
                      : CliquePostSchema(name: cliqueName, members: membersList, fund: amount, isActive: isActive);
                      createCliquePost.postData(cls);
                      // Use the amount if withFunds is true
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:  AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async{
              await Authservice.instance.logout();
            },
             icon: Icon(IconData(0xe3b3,fontFamily: 'MaterialIcons')),
             color: Colors.white,
          )
        ],
        title: Text("Clique Ledger",style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold ),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5588A3), // Note the use of 0xFF prefix for hex colors
              Color(0xFF145374),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          
          ),
        
        ),
      ),
        body: Column(
          children: [
            const TabBar(tabs:[
              Tab(child:Text("Active Ledger",style:TextStyle(color: Color.fromARGB(255, 14, 97, 130)),),),
              Tab(child: Text("Finished Ledger",style:TextStyle(color: Color.fromARGB(255, 14, 97, 130))),)
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  isCliquesLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : cliqueList.activeCliqueList.isEmpty
                          ? const Center(
                              child: Text("No Ledgers to show"),
                            )
                          : LedgerTab(cliqueList: cliqueList.activeCliqueList),
                            cliqueList.finishedCliqueList.isEmpty ? const Center(child: Text("No Ledgers to Show"),):
                            LedgerTab(cliqueList: cliqueList.finishedCliqueList)
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createClique(context),
          tooltip: 'Create Clique',
          child: const Icon(Icons.add),
          backgroundColor:Color.fromARGB(255, 165, 229, 244),
        ),
      ),
    );
  }
}

class LedgerTab extends StatelessWidget {
  final List<Clique> cliqueList;
  const LedgerTab({required this.cliqueList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cliqueList.map((clique) {
        return Center(
          child: Container(
            //margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            width: MediaQuery.of(context).size.width * 0.95,
            height: 90,
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: (){
                      context.read<CliqueProvider>().setClique(clique);
                      context.go(RoutersConstants.CLIQUE_ROUTE);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 213, 225, 236),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                      child: Container(
                        child: Column(
                          children: [
                              Text('${clique.name}',
                                  style: TextStyle(
                                   fontSize: 22.0,
                                 ),
                              ),
                              Text(
                                '${clique.latestTransaction.sender}-${clique.latestTransaction.spendAmount!=null ? clique.latestTransaction.sendAmount : clique.latestTransaction.sendAmount} \u{20B9}',
                                 style: TextStyle(color: Colors.grey,fontSize: 12),
                              ),
                               Text(
                                  '${clique.latestTransaction.date}',
                                   style: TextStyle(color: Colors.grey,fontSize: 10),
                               )
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Logout"),
      onPressed: () async {
        Authservice.instance.logout();
      },
    );
  }
}
