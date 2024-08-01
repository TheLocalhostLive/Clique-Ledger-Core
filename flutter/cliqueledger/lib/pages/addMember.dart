import 'package:cliqueledger/api_helpers/fetchMemeber.dart';
import 'package:cliqueledger/models/member.dart';
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/material.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final MemberList memberList = MemberList();
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  Future<void> _searchMember() async {
    setState(() {
      isLoading = true;
    });

    await memberList.fetchMembersByEmail(_searchController.text);

    setState(() {
      isLoading = false;
    });
  }

  void _addMember(Member member) {
    // Implement your logic to add the member
    print("Member added: ${member.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "Clique Ledger"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Search Member",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: "eg: ant@example.com",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _searchMember,
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: memberList.members.length,
                  itemBuilder: (context, index) {
                    final member = memberList.members[index];
                    return ListTile(
                      title: Text(member.name),
                      trailing: ElevatedButton(
                        onPressed: () => _addMember(member),
                        child: const Text("Add"),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
