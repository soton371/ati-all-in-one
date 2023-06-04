import 'package:ati_all_in_one/blocs/auth/login_bloc.dart';
import 'package:ati_all_in_one/blocs/get_image/get_image_bloc.dart';
import 'package:ati_all_in_one/configs/my_colors.dart';
import 'package:ati_all_in_one/configs/my_routes.dart';
import 'package:ati_all_in_one/configs/my_text_theme.dart';
import 'package:ati_all_in_one/configs/my_theme.dart';
import 'package:ati_all_in_one/screens/auth/log_in_scr.dart';
import 'package:ati_all_in_one/widgets/my_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          //for avatar
          Container(
            color: MyColors.darkBlue,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      BlocBuilder<GetImageBloc, GetImageState>(
                        builder: (context, state) {
                          if (state is GetImageInitial) {
                            return const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                              radius: 50,
                            );
                          } else if (state is GetImageSuccessState) {
                            return CircleAvatar(
                              backgroundImage: FileImage(state.imageFile),
                              radius: 50,
                            );
                          } else if (state is GetImageFailedState) {
                            return const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                              radius: 50,
                            );
                          } else {
                            return const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                              radius: 50,
                            );
                          }
                        },
                      ),

                      //for tap to pick image
                      InkWell(
                        onTap: () => myAlertDialog(context, 'Add Image', '',
                            actions: [
                              CupertinoButton(
                                  child: Column(
                                    children: const [
                                      Icon(Icons.image),
                                      Text('Gallery')
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                      .read<GetImageBloc>()
                                      .add(const PickImageEvent(0));
                                  } ),
                              CupertinoButton(
                                  child: Column(
                                    children: const [
                                      Icon(Icons.camera),
                                      Text('Camera')
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                      .read<GetImageBloc>()
                                      .add(const PickImageEvent(1));
                                  }),
                            ],
                            barrierDismissible: true),
                        
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: MyTheme.isDarkMode(context)
                              ? MyColors.black
                              : MyColors.white,
                          child: const Icon(
                            Icons.edit,
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  '\nUser Name',
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize:
                        MyTextTheme.font(context).titleLarge!.fontSize ?? 15,
                  ),
                ),
                Text(
                  'User Designation',
                  style: TextStyle(
                      color: MyColors.white,
                      fontSize:
                          MyTextTheme.font(context).bodyMedium!.fontSize ?? 15,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          //end avatar

          const Divider(
            height: 2,
          ),

          //for list items
          ListTile(
            onTap: () => Navigator.pop(context),
            iconColor: MyColors.white,
            textColor: MyColors.white,
            tileColor: MyColors.darkBlue,
            leading: const Icon(Icons.person),
            title: const Text('HR'),
          ),
          const Divider(
            height: 0.5,
          ),
          ListTile(
            iconColor: MyColors.white,
            textColor: MyColors.white,
            tileColor: MyColors.darkBlue,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              context.read<LoginBloc>().add(DoLogoutEvent());
              MyRoutes.pushAndRemoveUntil(context, const LogInScreen());
            },
          )
          //end list items
        ],
      ),
    );
  }
}
