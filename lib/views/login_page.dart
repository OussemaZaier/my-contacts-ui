import 'package:contacts_flutter/view_models/login_view_model.dart';
import 'package:contacts_flutter/views/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool visible = false;

  var animationLink = 'assets/rive/login.riv';
  StateMachineController? stateMachineController;
  Artboard? artboard;
  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;

  @override
  void initState() {
    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, "Login Machine");

      if (stateMachineController != null) {
        art.addController(stateMachineController!);

        for (var element in stateMachineController!.inputs) {
          if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "numLook") {
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() => artboard = art);
    });
    super.initState();
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(value) {
    lookNum?.change(value.length.toDouble());
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    context
        .read<LoginViewModel>()
        .login(emailController.text, passwordController.text);
    if (context.read<LoginViewModel>().error != null) {
      failTrigger?.fire();
    } else {
      successTrigger?.fire();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ContactsPage(), // Replace with the widget of your next page
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: artboard != null
                  ? Rive(
                      artboard: artboard!,
                    )
                  : const SizedBox(),
            ),
            loginForm(),
          ],
        ),
      ),
    );
  }

  Padding loginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            onTap: lookAround,
            onChanged: ((value) => moveEyes(value)),
            decoration: InputDecoration(
              hintText: 'emailEXAMPLE@email.com',
              labelText: 'E-Mail',
              prefixIcon: const Icon(Icons.email),
              suffixIcon: emailController.text.isEmpty
                  ? Container(
                      width: 0,
                    )
                  : IconButton(
                      onPressed: () {
                        emailController.clear();
                      },
                      icon: const Icon(Icons.close),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: passwordController,
            onTap: handsUpOnEyes,
            obscureText: !visible,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: '******',
              labelText: 'password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: visible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          visible = false;
                          handsUpOnEyes();
                        });
                      },
                      icon: const Icon(Icons.visibility))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          visible = true;
                          lookAround();
                        });
                      },
                      icon: const Icon(Icons.visibility_off)),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: MaterialButton(
              onPressed: () => {
                loginClick(),
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
