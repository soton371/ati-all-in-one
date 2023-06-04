import 'dart:convert';

import 'package:ati_all_in_one/blocs/fetch_app_list/fetch_app_list_bloc.dart';
import 'package:ati_all_in_one/blocs/auth/login_bloc.dart';
import 'package:ati_all_in_one/configs/my_colors.dart';
import 'package:ati_all_in_one/configs/my_routes.dart';
import 'package:ati_all_in_one/configs/my_sizes.dart';
import 'package:ati_all_in_one/configs/my_text_theme.dart';
import 'package:ati_all_in_one/configs/my_urls.dart';
import 'package:ati_all_in_one/models/checklist_model.dart';
import 'package:ati_all_in_one/screens/dashboard/dashboard_scr.dart';
import 'package:ati_all_in_one/screens/auth/components/my_painter.dart';
import 'package:ati_all_in_one/utilities/launch_url.dart';
import 'package:ati_all_in_one/widgets/my_alert_dialog.dart';
import 'package:ati_all_in_one/widgets/my_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool rememberIs = false;
  bool obscureTextIs = true;
  String email = '';
  String password = '';
  String msgE = '';
  String msgP = '';
  int i = 0;
  List<String> typeList = ['Text','Dropdown','Radio','Checkbox'];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            myLoader(context, 'Logging..');
          } else if (state is InternetExceptionState) {
            Navigator.pop(context);
            myAlertDialog(context, state.msgT, state.msgC, actions: [
              CupertinoButton(
                  child: const Text('Dismiss'),
                  onPressed: () => Navigator.pop(context))
            ]);
          } else if (state is TimeoutExceptionState) {
            Navigator.pop(context);
            myAlertDialog(context, state.msgT, state.msgC, actions: [
              CupertinoButton(
                  child: const Text('Dismiss'),
                  onPressed: () => Navigator.pop(context))
            ]);
          } else if (state is LoginFailedState) {
            Navigator.pop(context);
            myAlertDialog(context, state.msgT, state.msgC, actions: [
              CupertinoButton(
                  child: const Text('Dismiss'),
                  onPressed: () => Navigator.pop(context))
            ]);
          } else if (state is LoginSuccessState) {
            context.read<FetchAppListBloc>().add(DoFetchAppListEvent());
            // MyRoutes.pushAndRemoveUntil(context, const DashboardScreen());
            //for take some input fields
          } else if (state is RecommendedAlertState) {
            Navigator.pop(context);
            state.updateIs
                ? myAlertDialog(context, state.title, state.content, actions: [
                    CupertinoButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: MyColors.uninstall),
                        ),
                        onPressed: () => Navigator.pop(context)),
                    CupertinoButton(
                        child: const Text('Go to Store'),
                        onPressed: () => launchAppStore(MyUrls.appStoreLink)),
                  ])
                : myAlertDialog(context, state.title, state.content);
          } else if (state is NoNeedAlertState) {
            MyRoutes.pushAndRemoveUntil(context, const DashboardScreen());
          }
        },
        child: SafeArea(
          //this container for background
          child: Stack(
            children: [
              //for Circle
              Positioned(
                // top: 200,
                top: MySizes.height(context) / 4,
                child: CustomPaint(
                  painter: MyPainter(MySizes.width(context) / 1.1),
                ),
              ),

              //for log in element
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                //this column hold all contents
                child: Padding(
                  padding: const EdgeInsets.all(MySizes.bodyPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/images/ATI-logo-small.png',
                        height: MySizes.height(context) / 14,
                      ),

                      const Spacer(flex: 1),

                      Text(
                        'Sign in\n',
                        style: TextStyle(
                            fontSize: MyTextTheme.font(context)
                                    .headlineMedium!
                                    .fontSize ??
                                20,
                            color: Colors.white),
                      ),

                      //for text field
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MySizes.radius),
                            border: Border.all(color: MyColors.blueGrey)),
                        padding: const EdgeInsets.all(MySizes.bodyPadding),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (v) {
                                setState(() {
                                  email = v;
                                  email.isNotEmpty ? msgE = '' : null;
                                });
                              },
                              style: const TextStyle(color: MyColors.white),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: MyColors.white,
                              decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: MyColors.white)),
                                  labelText: 'User Name/Email',
                                  labelStyle:
                                      const TextStyle(color: MyColors.white),
                                  errorText: msgE.isEmpty ? null : msgE,
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: MyColors.white,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (v) {
                                setState(() {
                                  password = v;
                                  password.isNotEmpty ? msgP = '' : null;
                                });
                              },
                              obscureText: obscureTextIs,
                              style: const TextStyle(color: MyColors.white),
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: MyColors.white,
                              decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: MyColors.white)),
                                  labelText: 'Password',
                                  labelStyle:
                                      const TextStyle(color: MyColors.white),
                                  errorText: msgP.isEmpty ? null : msgP,
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: MyColors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscureTextIs = !obscureTextIs;
                                      });
                                    },
                                    icon: Icon(
                                      obscureTextIs
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: MyColors.blueGrey,
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ), //end text field

                      const Spacer(flex: 1),

                      //for check box remember me
                      Row(
                        children: [
                          Checkbox(
                              value: rememberIs,
                              checkColor: MyColors.darkBlue,
                              fillColor:
                                  MaterialStateProperty.all(MyColors.white),
                              onChanged: (v) => setState(() {
                                    rememberIs = v ?? false;
                                  })),
                          const Text(
                            'Remember me',
                            style: TextStyle(color: MyColors.white),
                          )
                        ],
                      ), //end check box remember me

                      const SizedBox(
                        height: 10,
                      ),

                      //for sign in button
                      ElevatedButton(
                          onPressed: () {
                            if (email.isEmpty) {
                              setState(() {
                                msgE = 'Email field is empty';
                              });
                            } else if (password.isEmpty) {
                              setState(() {
                                msgP = 'Password field is empty';
                              });
                            } else {
                              setState(() {
                                msgP = '';
                                msgE = '';
                              });
                              context.read<LoginBloc>().add(
                                  DoLoginEvent(email, password, rememberIs));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.button,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(MySizes.radius))),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: MyColors.white),
                          )),
                      //end sign in button

                      const Spacer(
                        flex: 4,
                      ),

                      ElevatedButton(
                          onPressed: () {
                            String inputType = typeList[i];
                            if (inputType.isNotEmpty && inputType == 'Text') {
                              myInputAlertDialog(context);
                            } else if (inputType.isNotEmpty &&
                                inputType == 'Dropdown') {
                              myDropdownAlertDialog(context, items: [
                                'Item1',
                                'Item2',
                                'Item3',
                                'Item4',
                              ]);
                            } else if (inputType.isNotEmpty &&
                                inputType == 'Radio') {
                              myRadioAlertDialog(context,
                                  options: ['A', 'B'], selectedOption: 'A');
                            } else if (inputType.isNotEmpty &&
                                inputType == 'Checkbox') {
                              final checklists =
                                  checklistModelFromJson(jsonEncode([
                                {"title": "One", "value": false},
                                {"title": "Two", "value": false}
                              ]));
                              myCheckboxAlertDialog(context,
                                  checkLists: checklists);
                            }
                            if (i<3) {
                              i++;
                            }else{
                              i=0;
                            }
                          },
                          child: const Text('Demo')),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Develop by ',
                            style: MyTextTheme.font(context).titleLarge,
                          ),
                          Image.asset(
                            'assets/images/ATI-logo-small.png',
                            height: MySizes.height(context) / 20,
                          )
                        ],
                      ),

                      const Spacer(flex: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
