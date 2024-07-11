import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: IconButton.filled(
                  icon: const Icon(
                    Icons.add_a_photo_rounded,
                    size: 30,
                    color: Colors.black87,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 200,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: "Name",
                        border: UnderlineInputBorder()),
                  ),
                  const Spacer(),
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.key),
                        hintText: "Username",
                        border: UnderlineInputBorder(),
                        helperText: "This should be unique"),
                  ),
                  const Spacer(),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        hintText: "Password",
                        border: UnderlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),

          // -------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {},
                label: const Text("Sign Up"),
                icon: const Icon(Icons.arrow_forward_rounded),
              )
            ],
          )
        ],
      ),
    );
  }
}
