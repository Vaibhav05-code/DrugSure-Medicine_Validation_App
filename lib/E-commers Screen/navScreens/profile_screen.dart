import 'package:drugsuremva/E-commers%20Screen/providers/user_provider_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget buildItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.green.shade600),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget dividerWidget() {
    return Divider(
      thickness: 0.7,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green.shade600,
        title: const Text("My Profile", style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 45, color: Colors.green.shade600),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nameOfUser,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.emailOfUser,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, "/update_profile");
                    },
                    icon: const Icon(Icons.edit_outlined,
                        color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Account options
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Column(
                children: [
                  buildItem(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    onTap: () {
                      // Navigator.pushNamed(context, "/orders");
                    },
                  ),
                  dividerWidget(),
                  buildItem(
                    icon: Icons.location_on_outlined,
                    title: "Delivery Address",
                    onTap: () {
                      // Navigator.pushNamed(context, "/addresses");
                    },
                  ),
                  dividerWidget(),
                  buildItem(
                    icon: Icons.payment_outlined,
                    title: "Payment Methods",
                    onTap: () {
                      // Navigator.pushNamed(context, "/payments");
                    },
                  ),
                ],
              ),
            ),

            // Settings card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Column(
                children: [
                  buildItem(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {},
                  ),
                  dividerWidget(),
                  buildItem(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Logout button
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: buildItem(
                icon: Icons.logout_outlined,
                title: "Logout",
                iconColor: Colors.red,
                onTap: () async {
                  Provider.of<UserProvider>(context, listen: false)
                      .declineProvider();

                  await FirebaseAuth.instance.signOut();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                        (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
