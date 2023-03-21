import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddUserDialog extends StatefulWidget {
  AddUserDialog({
    super.key,
    User? user,
    this.isEdit = false,
  }) : user = user ?? User();

  User user;
  bool isEdit;

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  ApiService apiService = ApiService();
  final formKey = GlobalKey<FormState>();

  TextEditingController _nip = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _site = TextEditingController();

  FocusNode nipNode = FocusNode();
  FocusNode fullNameNode = FocusNode();
  FocusNode siteNode = FocusNode();
  FocusNode roleNode = FocusNode();

  String nip = "";
  String name = "";

  String selectedSite = "";
  String selectedRole = "Store Admin";

  OverlayEntry? siteOverlayEntry;
  GlobalKey siteKey = GlobalKey();
  LayerLink siteLayerLink = LayerLink();
  bool isOverlaySiteOpen = false;

  final List<String> siteList = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
  ];

  List roleList = [];

  String? selectedValue;

  OverlayEntry siteOverlay() {
    RenderBox? renderBox =
        siteKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
            // left: offset.dx,
            // top: offset.dy + size.height + 10,
            width: size.width,
            child: CompositedTransformFollower(
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 5.0),
              link: siteLayerLink,
              child: Material(
                elevation: 4.0,
                color: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SiteSearchContainer(
                  onClick: onClickSite,
                ),
              ),
            )));
  }

  onClickSite(String id, String name) {
    _site.text = "$id - $name";
    selectedSite = id;
    if (isOverlaySiteOpen) {
      if (siteOverlayEntry!.mounted) {
        siteOverlayEntry!.remove();
      }
      siteNode.unfocus();
    }
    setState(() {});
  }

  initListSite() {}
  initListRole() {
    apiService.getRoleListDropdown().then((value) {
      if (value['Status'].toString() == "200") {
        roleList = value['Data'];
        setState(() {});
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
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getRoleList",
          contentText: "No internet connection.",
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initListRole();
    if (widget.isEdit) {
      _nip.text = widget.user.nip;
      _fullName.text = widget.user.name;
      _site.text = "${widget.user.siteId} - ${widget.user.siteName}";
      selectedSite = widget.user.siteId;
      selectedRole = widget.user.role;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 400,
          minWidth: 500,
          maxWidth: 720,
        ),
        child: GestureDetector(
          onTap: () {
            if (isOverlaySiteOpen) {
              if (siteOverlayEntry!.mounted) {
                siteOverlayEntry!.remove();
              }
              siteNode.unfocus();
              isOverlaySiteOpen = false;
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 35,
                bottom: 30,
                left: 40,
                right: 40,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Data",
                      style: helveticaText.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: eerieBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Create or edit user data',
                      style: helveticaText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: davysGray,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    inputField(
                      'NIP',
                      widget: SizedBox(
                        width: 150,
                        child: BlackInputField(
                          controller: _nip,
                          enabled: true,
                          hintText: 'NIP here ...',
                          maxLines: 1,
                          validator: (value) =>
                              value == "" ? "This field is required" : null,
                          onSaved: (newValue) {
                            nip = newValue.toString();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    inputField(
                      'Full Name',
                      widget: Expanded(
                        child: BlackInputField(
                          controller: _fullName,
                          enabled: true,
                          hintText: 'Full name here ...',
                          validator: (value) =>
                              value == "" ? "This field is required" : null,
                          onSaved: (newValue) {
                            name = newValue.toString();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    inputField(
                      'Site',
                      // widget: Expanded(
                      //   child: LayoutBuilder(builder: (context, constraint) {
                      //     return BlackDropdown(
                      //       focusNode: siteNode,
                      //       hintText: 'Choose',
                      //       enabled: false,
                      //       items: siteList
                      //           .map((item) => DropdownMenuItem(
                      //                 value: item,
                      //                 child: Text(
                      //                   item,
                      //                   style: const TextStyle(
                      //                     fontSize: 14,
                      //                   ),
                      //                 ),
                      //               ))
                      //           .toList(),
                      //       value: selectedValue,
                      //       onChanged: (value) {
                      //         selectedSite = value;
                      //       },
                      //       suffixIcon: const Icon(
                      //         Icons.keyboard_arrow_down_outlined,
                      //         color: eerieBlack,
                      //       ),
                      //       validator: (value) =>
                      //           value == "" ? "This field is required" : null,
                      //     );
                      //   }),
                      // ),
                      widget: Expanded(
                        child: Container(
                          key: siteKey,
                          // onTap: () {},
                          child: CompositedTransformTarget(
                            link: siteLayerLink,
                            child: CustomInputField(
                              controller: _site,
                              focusNode: siteNode,
                              enabled: true,
                              hintText: 'Choose Site',
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: eerieBlack,
                              ),
                              onTap: () {
                                if (isOverlaySiteOpen) {
                                  isOverlaySiteOpen = false;
                                  if (siteOverlayEntry!.mounted) {
                                    siteOverlayEntry!.remove();
                                  }
                                } else {
                                  siteOverlayEntry = siteOverlay();
                                  Overlay.of(context)!
                                      .insert(siteOverlayEntry!);
                                  isOverlaySiteOpen = true;
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    inputField(
                      'Role',
                      widget: SizedBox(
                        width: 250,
                        child: BlackDropdown(
                          items: roleList
                              .map((item) => DropdownMenuItem(
                                    value: item['Value'],
                                    child: Text(
                                      item['Name'],
                                      style: helveticaText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: davysGray,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          enabled: true,
                          hintText: 'Choose',
                          value: widget.isEdit ? selectedRole : null,
                          onChanged: (value) {
                            selectedRole = value;
                          },
                          validator: (value) =>
                              value == "" ? "This field is required" : null,
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: eerieBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TransparentButtonBlack(
                          text: "Cancel",
                          disabled: false,
                          padding: ButtonSize().mediumSize(),
                          onTap: () {
                            Navigator.of(context).pop(0);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        RegularButton(
                          text: "Confirm",
                          disabled: false,
                          padding: ButtonSize().mediumSize(),
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              User userSave = User();
                              userSave.name = name;
                              userSave.nip = nip;
                              userSave.siteId = selectedSite;
                              userSave.role = selectedRole;
                              if (widget.isEdit) {
                                userSave.oldNip = widget.user.nip;
                                apiService.updateUser(userSave).then((value) {
                                  if (value['Status'].toString() == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                      ),
                                    ).then((value) {
                                      Navigator.of(context).pop(1);
                                    });
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
                                }).onError((error, stackTrace) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const AlertDialogBlack(
                                      title: "Error updateUser",
                                      contentText: "No internet connection.",
                                      isSuccess: false,
                                    ),
                                  );
                                });
                              } else {
                                apiService.addUser(userSave).then((value) {
                                  if (value['Status'].toString() == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                      ),
                                    ).then((value) {
                                      Navigator.of(context).pop(1);
                                    });
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
                                }).onError((error, stackTrace) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const AlertDialogBlack(
                                      title: "Error addUser",
                                      contentText: "No internet connection.",
                                      isSuccess: false,
                                    ),
                                  );
                                });
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(String label, {Widget? widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: SizedBox(
            width: 150,
            child: Text(
              label,
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
          ),
        ),
        widget!,
      ],
    );
  }
}

class SiteSearchContainer extends StatefulWidget {
  SiteSearchContainer({
    super.key,
    this.siteID = "",
    this.onClick,
  });
  String siteID;
  Function? onClick;

  @override
  State<SiteSearchContainer> createState() => _SiteSearchContainerState();
}

class _SiteSearchContainerState extends State<SiteSearchContainer> {
  TextEditingController _search = TextEditingController();
  ApiService apiService = ApiService();

  List siteList = [];

  onChange(String value) {
    siteList.clear();
    print(value);
    apiService.getSiteListDropdown(value).then((value) {
      if (value['Status'].toString() == "200") {
        siteList = value['Data'];
        setState(() {});
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();
    apiService.getSiteListDropdown("").then((value) {
      if (value['Status'].toString() == "200") {
        siteList = value['Data'];
        setState(() {});
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 250,
        maxHeight: 250,
        maxWidth: 360,
        minWidth: 360,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _search,
              cursorColor: davysGray,
              onChanged: (value) {
                onChange(value);
              },
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: davysGray,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: davysGray,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: davysGray,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 0,
                ),
                hintText: 'Search here ...',
              ),
            ),
            // const SizedBox(
            //   height: 15,
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: siteList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: InkWell(
                            onTap: () {
                              widget.onClick!(siteList[index]['SiteID'],
                                  siteList[index]['SiteName']);
                            },
                            child: Text(
                              '${siteList[index]["SiteID"]} - ${siteList[index]["SiteName"]}',
                              style: helveticaText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
