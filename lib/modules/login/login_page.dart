import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  ApiService apiService = ApiService();

  String username = "";
  String password = "";

  final formKey = GlobalKey<FormState>();

  submitLogin() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      apiService.login(username, password).then((value) {
        print(value);
        if (value['Status'].toString() == "200") {
          context.go('/home');
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialogBlack(
              title: value['Title'],
              contentText: value['Message'],
              isSuccess: false,
            ),
          );
        }
      }).onError((error, stackTrace) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: screenWidth,
                maxWidth: screenWidth,
                minHeight: screenHeight,
                maxHeight: screenHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'GA Decentralization System',
                    style: helveticaText.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    width: 400,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Please login using your HCPlus credential.',
                            style: helveticaText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Username',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: davysGray,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlackInputField(
                            controller: _username,
                            enabled: true,
                            maxLines: 1,
                            validator: (value) =>
                                value == "" ? "This field is required." : null,
                            hintText: "Username here ...",
                            onSaved: (newValue) {
                              username = newValue.toString();
                            },
                            onFieldSubmitted: (value) {
                              submitLogin();
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Password',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: davysGray,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlackInputField(
                            controller: _password,
                            enabled: true,
                            obsecureText: true,
                            maxLines: 1,
                            validator: (value) =>
                                value == "" ? "This field is required." : null,
                            hintText: "Password here ...",
                            onSaved: (newValue) {
                              password = newValue.toString();
                            },
                            onFieldSubmitted: (value) {
                              submitLogin();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 65,
                  ),
                  RegularButton(
                    text: 'Login',
                    disabled: false,
                    padding: ButtonSize().longSize(),
                    onTap: () {
                      submitLogin();
                    },
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: SizedBox(
              width: 155,
              height: 50,
              child: Image.asset(
                'assets/navbarlogo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
