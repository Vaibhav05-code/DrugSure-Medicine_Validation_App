import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> signupUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (passwordController.text != confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Passwords do not match"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCred.user;

        if (user != null) {
          await _firestore.collection("users").doc(user.uid).set({
            "uid": user.uid,
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "createdAt": DateTime.now(),
          });

          await user.updateDisplayName(nameController.text.trim());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Signup Failed";

        if (e.code == 'weak-password') {
          errorMessage = "Password is too weak";
        } else if (e.code == 'email-already-in-use') {
          errorMessage = "An account already exists with this email";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Invalid email format";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade100, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade700,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.shade200,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.medical_services, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // App Title
                  Text(
                    "DrugSure",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    "Create Your Account",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  // Name Field
                  _buildInputField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person,
                    validator: (v) => v!.isEmpty ? "Enter your name" : null,
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  _buildInputField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email,
                    validator: (v) => v!.isEmpty || !v.contains("@")
                        ? "Enter a valid email"
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  _buildInputField(
                    controller: passwordController,
                    label: "Password",
                    icon: Icons.lock,
                    obscure: _obscurePassword,
                    toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    validator: (v) => v!.length < 6 ? "Min 6 characters" : null,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  _buildInputField(
                    controller: confirmPasswordController,
                    label: "Confirm Password",
                    icon: Icons.lock_outline,
                    obscure: _obscureConfirmPassword,
                    toggleObscure: () =>
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    validator: (v) =>
                    v != passwordController.text ? "Passwords do not match" : null,
                  ),
                  const SizedBox(height: 30),

                  // Signup Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : signupUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("SIGN UP",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(color: Colors.grey.shade700)),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        ),
                        child: Text("Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable TextField Widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal.shade700),
        suffixIcon: toggleObscure != null
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.teal.shade700),
          onPressed: toggleObscure,
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
        ),
      ),
    );
  }
}
