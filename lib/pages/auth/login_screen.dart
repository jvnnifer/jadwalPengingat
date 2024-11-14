import 'package:flutter/material.dart';
import 'package:jadwal_pelajaran_app/pages/home_page.dart';
import 'signup.dart';
import '../../pages/tugas_mapel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/tugas_mapel_services.dart';

class LoginScreen extends StatefulWidget {
  final List<User>? userList;
  const LoginScreen({super.key, this.userList});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  late List<User> _userList = <User>[];
  var _userService = UserService();

  getAllUsers() async {
    var users = await _userService.readAllUser();
    _userList = <User>[];
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.userId = user['userId'];
        userModel.username = user['username'];
        userModel.password = user['password'];
        _userList.add(userModel);
      });
    });
  }

  void initState() {
    super.initState();
    getAllUsers();
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red),
    );
  }

  Future<void> login() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      setState(() {
        isLogin = false;
      });
      return;
    }

    setState(() {
      isLogin = false;
    });

    User? matchedUser;
    try {
      matchedUser = _userList.firstWhere((user) =>
          user.username == username.text && user.password == password.text);
    } catch (e) {
      matchedUser = null;
    }

    if (matchedUser != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', matchedUser.userId!);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        isLogin = true;
      });
    }
    username.clear();
    password.clear();
  }

  bool isVisible = false;
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                children: [
                  Image.asset(
                    "lib/images/login.png",
                    width: 210,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blueAccent.withOpacity(.2)),
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "username is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Username",
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blueAccent.withOpacity(.2)),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password is required";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  //toggle button
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),

                  const SizedBox(height: 10),
                  //Login button
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue),
                    child: TextButton(
                        onPressed: () async {
                          await login();
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun?"),
                      TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text("SIGN UP"))
                    ],
                  ),
                  isLogin
                      ? const Text('Username atau password tidak valid',
                          style: TextStyle(color: Colors.red))
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
