import 'package:contacts_flutter/view_models/login_view_model.dart';
import 'package:contacts_flutter/views/contacts_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  final bool isSignUp;

  const LoginPage({super.key, this.isSignUp = false});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool visible = false;
  bool rememberMe = true;

  var animationLink = 'assets/rive/login.riv';
  StateMachineController? stateMachineController;
  Artboard? artboard;
  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
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
    }
    if (context.read<LoginViewModel>().res != null) {
      successTrigger?.fire();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ContactsPage(), // Replace with the widget of your next page
        ),
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            widget.isSignUp ? signForm() : loginForm(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.isSignUp
                          ? 'Already have an account? '
                          : 'don\'t have an account? ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          final nextPage = widget.isSignUp
                              ? const LoginPage()
                              : const LoginPage(isSignUp: true);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: nextPage,
                                );
                              },
                            ),
                          );
                        },
                      text: widget.isSignUp ? 'Sign in here' : 'Sign up here',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email address',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: emailController,
            onTap: lookAround,
            onChanged: ((value) => moveEyes(value)),
            decoration: InputDecoration(
              hintText: 'enter your email',
              // labelText: 'E-Mail',
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
            height: 15,
          ),
          Text(
            'password',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: passwordController,
            onTap: handsUpOnEyes,
            obscureText: !visible,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'enter your password',
              // labelText: 'password',
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
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              InkWell(
                onTap: () => setState(() {
                  rememberMe = !rememberMe;
                }),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).indicatorColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      rememberMe ? const Icon(Icons.check) : const SizedBox(),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Remember me',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Text(
                'Forgot password',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: MaterialButton(
              onPressed: () => {
                loginClick(),
              },
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding signForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: emailController,
            onTap: lookAround,
            onChanged: ((value) => moveEyes(value)),
            decoration: InputDecoration(
              hintText: 'enter your username',
              // labelText: 'E-Mail',
              prefixIcon: const Icon(Icons.account_box_rounded),
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
            height: 15,
          ),
          Text(
            'Email address',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: emailController,
            onTap: lookAround,
            onChanged: ((value) => moveEyes(value)),
            decoration: InputDecoration(
              hintText: 'enter your email',
              // labelText: 'E-Mail',
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
            height: 15,
          ),
          Text(
            'password',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: passwordController,
            onTap: handsUpOnEyes,
            obscureText: !visible,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'enter your password',
              // labelText: 'password',
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
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              InkWell(
                onTap: () => setState(() {
                  rememberMe = !rememberMe;
                }),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).indicatorColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      rememberMe ? const Icon(Icons.check) : const SizedBox(),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Remember me',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Text(
                'Forgot password',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: MaterialButton(
              onPressed: () => {
                loginClick(),
              },
              child: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
