import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/view/admin_settings/user/add_user_dialog.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class UserListContainer extends StatefulWidget {
  UserListContainer({
    super.key,
    User? user,
    this.index = 0,
    this.onClick,
    this.close,
    this.menu = "",
    this.updateList,
  }) : user = user ?? User();

  User user;
  int index;
  Function? onClick;
  Function? close;
  Function? updateList;
  String menu;

  @override
  State<UserListContainer> createState() => _UserListContainerState();
}

class _UserListContainerState extends State<UserListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index != 0
            ? const Divider(
                thickness: 0.5,
                color: grayStone,
              )
            : const SizedBox(),
        InkWell(
          onTap: () {
            if (widget.user.isExpanded) {
              widget.close!(widget.index);
            } else {
              widget.onClick!(widget.index);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 19),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 135,
                      child: Text(
                        widget.user.nip,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.user.name,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        widget.user.siteId,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.user.role,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: !widget.user.isExpanded
                          ? const Icon(
                              Icons.keyboard_arrow_right_sharp,
                            )
                          : const Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                    ),
                  ],
                ),
                !widget.user.isExpanded
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: RegularButton(
                                    text: 'Edit',
                                    disabled: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AddUserDialog(
                                          isEdit: true,
                                          user: widget.user,
                                        ),
                                      ).then((value) {
                                        widget.updateList!(widget.menu);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: DeleteButton(
                                    text: 'Delete',
                                    disabled: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const ConfirmDialogBlack(
                                          title: "Confirmation",
                                          contentText:
                                              "Are you sure to delete user?",
                                        ),
                                      ).then((value) {
                                        if (value == 1) {
                                          ApiService apiService = ApiService();
                                          apiService
                                              .deleteUser(widget.user.nip)
                                              .then((value) {
                                            if (value['Status'].toString() ==
                                                "200") {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialogBlack(
                                                  title: value['Title'],
                                                  contentText: value['Message'],
                                                ),
                                              ).then((value) {
                                                widget.updateList!(widget.menu);
                                              });
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialogBlack(
                                                  title: value['Title'],
                                                  contentText: value['Message'],
                                                  isSuccess: false,
                                                ),
                                              );
                                            }
                                          }).onError((error, stackTrace) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const AlertDialogBlack(
                                                title: "Error deleteUser",
                                                contentText:
                                                    "No internet connection",
                                                isSuccess: false,
                                              ),
                                            );
                                          });
                                        }
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
