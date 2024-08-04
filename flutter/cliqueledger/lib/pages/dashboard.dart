import 'package:cliqueledger/api_helpers/fetchActiveLedgerContent.dart';
import 'package:cliqueledger/models/cliqeue.dart';
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
  final ActiveLedgerContentList activeLedgerContentList =
      ActiveLedgerContentList();

  bool isActiveLeedgerLoading = true;
  bool isFinishLedgerLoading = true;
  @override
  void initState() {
    super.initState();
    fetchActiveLeger();
    //fetchFinishLedger();
  }

  Future<void> fetchActiveLeger() async {
    await activeLedgerContentList.fetchData();
    setState(() {
      isActiveLeedgerLoading = false;
    });
  }

  Future<void> FetchFinishLedger() async {
    setState(() {
      isFinishLedgerLoading = false;
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
            TabBar(tabs: [
              Tab(text: "Active Ledger"),
              Tab(text: "Finished Ledger")
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  isActiveLeedgerLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : activeLedgerContentList.activeCliqueList.isEmpty
                          ? const Center(
                              child: Text("No Ledgers to show"),
                            )
                          : LedgerTab(
                              cliqueList: activeLedgerContentList.activeCliqueList),
                        Center(child: Text("Nothing To show"),)

                  // isFinishLedgerLoading
                  // ? const Center(child: CircularProgressIndicator(),)
                  // :
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
            height: 80,
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
                      padding: const EdgeInsets.fromLTRB(15, 20, 5, 10),
                      child: Container(
                        child: Text(
                          '${clique.name}',
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
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
