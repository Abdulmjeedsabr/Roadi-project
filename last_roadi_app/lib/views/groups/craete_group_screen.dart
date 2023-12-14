import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as cc;
import 'package:get/get.dart';
import 'package:last_roadi_app/controller/create_group_controller.dart';
import 'package:last_roadi_app/utiles/app_constants.dart';
import 'package:last_roadi_app/utiles/styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChatCreateGroupScreen extends StatefulWidget {
  const ChatCreateGroupScreen(
      {Key? key,
      this.title,
      this.createIcon,
      this.namePlaceholderText,
      this.closeIcon,
      this.disableCloseButton,
      this.onCreateTap,
      this.createGroupStyle = const CreateGroupStyle(),
      this.theme,
      this.passwordPlaceholderText,
      this.onBack,
      this.onError})
      : super(key: key);

  ///[title] Title of the component
  final String? title;

  ///[createIcon] create icon widget
  final Widget? createIcon;

  ///[closeIcon] close icon widget
  final Widget? closeIcon;

  ///[namePlaceholderText] group name input placeholder
  final String? namePlaceholderText;

  ///[passwordPlaceholderText] group password input placeholder
  final String? passwordPlaceholderText;

  ///[disableCloseButton] toggle visibility for close button
  final bool? disableCloseButton;

  ///[theme] instance of cometchat theme
  final CometChatTheme? theme;

  ///[onCreateTap] triggered on create group icon click
  final Function(Group group)? onCreateTap;

  ///[createGroupStyle] styling properties
  final CreateGroupStyle createGroupStyle;

  ///[onError] callback triggered in case any error happens when trying to create group
  final OnError? onError;

  ///[onBack] callback triggered on closing this screen
  final VoidCallback? onBack;

  @override
  State<ChatCreateGroupScreen> createState() => _ChatCreateGroupScreenState();
}

class _ChatCreateGroupScreenState extends State<ChatCreateGroupScreen>
    with SingleTickerProviderStateMixin {
  late CreateGroupController createGroupController;
  late CometChatTheme theme;
  final DateRangePickerController dateController = DateRangePickerController();

  @override
  void initState() {
    theme = widget.theme ?? cometChatTheme;
    createGroupController = CreateGroupController(theme,
        onCreateTap: widget.onCreateTap, onError: widget.onError);
    createGroupController.tabController = TabController(length: 3, vsync: this);
    createGroupController.tabController
        .addListener(createGroupController.tabControllerListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> DayWidgets = AppConstants.days
        .map((day) => _buildDayWidget(day, createGroupController))
        .toList();
    return GetBuilder(
        init: createGroupController,
        tag: createGroupController.tag,
        builder: (CreateGroupController createGroupController) {
          return CometChatListBase(
              title: widget.title ?? cc.Translations.of(context).new_group,
              theme: theme,
              backIcon: widget.closeIcon ??
                  Image.asset(
                    AssetConstants.close,
                    package: UIConstants.packageName,
                    color: widget.createGroupStyle.closeIconTint ??
                        theme.palette.getPrimary(),
                  ),
              showBackButton: !(widget.disableCloseButton == true),
              onBack: widget.onBack,
              hideSearch: true,
              style: ListBaseStyle(
                  backIconTint: widget.createGroupStyle.closeIconTint ??
                      theme.palette.getPrimary(),
                  background: widget.createGroupStyle.background ??
                      theme.palette.getBackground(),
                  titleStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: theme.palette.getAccent())
                      .merge(widget.createGroupStyle.titleTextStyle),
                  gradient: widget.createGroupStyle.gradient,
                  border: widget.createGroupStyle.border,
                  borderRadius: widget.createGroupStyle.borderRadius,
                  height: widget.createGroupStyle.height,
                  width: widget.createGroupStyle.width),
              menuOptions: [
                IconButton(
                    onPressed: () async {
                      createGroupController.onCreateIconCLick(context);
                    },
                    icon: widget.createIcon ??
                        Image.asset(
                          AssetConstants.checkmark,
                          package: UIConstants.packageName,
                          color: widget.createGroupStyle.createIconTint ??
                              theme.palette.getPrimary(),
                        ))
              ],
              container: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Form(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 56,
                            child: TextFormField(
                              initialValue: createGroupController.groupName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return cc.Translations.of(context)
                                      .enter_group_name;
                                }
                                return null;
                              },
                              onChanged: createGroupController.onNameChange,
                              maxLength: 25,
                              style: widget
                                      .createGroupStyle.nameInputTextStyle ??
                                  TextStyle(
                                    color: theme.palette.getAccent(),
                                    fontSize: theme.typography.body.fontSize,
                                    fontFamily:
                                        theme.typography.body.fontFamily,
                                    fontWeight:
                                        theme.typography.body.fontWeight,
                                  ),
                              decoration: InputDecoration(
                                  counterText: '',
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget
                                                .createGroupStyle.borderColor ??
                                            theme.palette.getAccent100()),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget
                                                .createGroupStyle.borderColor ??
                                            theme.palette.getAccent100()),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.palette.getAccent100()),
                                  ),
                                  hintText: widget.namePlaceholderText ??
                                      cc.Translations.of(context).name,
                                  hintStyle: widget.createGroupStyle
                                          .namePlaceholderTextStyle ??
                                      TextStyle(
                                        color: theme.palette.getAccent600(),
                                        fontSize:
                                            theme.typography.body.fontSize,
                                        fontFamily:
                                            theme.typography.body.fontFamily,
                                        fontWeight:
                                            theme.typography.body.fontWeight,
                                      )),
                              keyboardAppearance:
                                  theme.palette.mode == PaletteThemeModes.light
                                      ? Brightness.light
                                      : Brightness.dark,
                            ),
                          ),
                          SizedBox(
                            height: 56,
                            child: TextFormField(
                              initialValue: createGroupController.groupName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Location';
                                }
                                return null;
                              },
                              onChanged:
                                  createGroupController.onDescriptionChange,
                              maxLength: 25,
                              readOnly: true,
                              style: widget
                                      .createGroupStyle.nameInputTextStyle ??
                                  TextStyle(
                                    color: theme.palette.getAccent(),
                                    fontSize: theme.typography.body.fontSize,
                                    fontFamily:
                                        theme.typography.body.fontFamily,
                                    fontWeight:
                                        theme.typography.body.fontWeight,
                                  ),
                              decoration: InputDecoration(
                                  counterText: '',
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget
                                                .createGroupStyle.borderColor ??
                                            theme.palette.getAccent100()),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget
                                                .createGroupStyle.borderColor ??
                                            theme.palette.getAccent100()),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.palette.getAccent100()),
                                  ),
                                  hintText: 'جامعة الجوف',
                                  hintStyle: widget.createGroupStyle
                                          .namePlaceholderTextStyle ??
                                      TextStyle(
                                        color: theme.palette.getAccent600(),
                                        fontSize:
                                            theme.typography.body.fontSize,
                                        fontFamily:
                                            theme.typography.body.fontFamily,
                                        fontWeight:
                                            theme.typography.body.fontWeight,
                                      )),
                              keyboardAppearance:
                                  theme.palette.mode == PaletteThemeModes.light
                                      ? Brightness.light
                                      : Brightness.dark,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // SizedBox(
                          //   height: 56,
                          //   child: TextFormField(
                          //     initialValue:
                          //         createGroupController.groupDescription,
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return 'Enter description here';
                          //       }
                          //       return null;
                          //     },
                          //     onChanged:
                          //         createGroupController.onDescriptionChange,
                          //     style: TextStyle(
                          //       color: theme.palette.getAccent(),
                          //       fontSize: theme.typography.body.fontSize,
                          //       fontFamily: theme.typography.body.fontFamily,
                          //       fontWeight: theme.typography.body.fontWeight,
                          //     ),
                          //     decoration: InputDecoration(
                          //         counterText: '',
                          //         border: UnderlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: widget
                          //                       .createGroupStyle.borderColor ??
                          //                   theme.palette.getAccent100()),
                          //         ),
                          //         enabledBorder: UnderlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: widget
                          //                       .createGroupStyle.borderColor ??
                          //                   theme.palette.getAccent100()),
                          //         ),
                          //         focusedBorder: UnderlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: theme.palette.getAccent100()),
                          //         ),
                          //         hintText: "Description",
                          //         hintStyle: widget.createGroupStyle
                          //                 .namePlaceholderTextStyle ??
                          //             TextStyle(
                          //               color: theme.palette.getAccent600(),
                          //               fontSize:
                          //                   theme.typography.body.fontSize,
                          //               fontFamily:
                          //                   theme.typography.body.fontFamily,
                          //               fontWeight:
                          //                   theme.typography.body.fontWeight,
                          //             )),
                          //     keyboardAppearance: Brightness.light,
                          //   ),
                          // ),
                          // selectDateWidget(createGroupController),
                          Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Day",
                                    style: robotoRegular.copyWith(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 143, 143, 143)),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                children: DayWidgets,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              selectTimeWidget(createGroupController),
                              const SizedBox(
                                height: 20,
                              ),
                              selectEndTimeWidget(createGroupController),
                            ],
                          ),

                          if (createGroupController.groupType ==
                              GroupTypeConstants.password)
                            SizedBox(
                              height: 56,
                              child: TextFormField(
                                initialValue:
                                    createGroupController.groupPassword,
                                validator: (value) {
                                  if (createGroupController.groupType ==
                                          GroupTypeConstants.password &&
                                      (value == null || value.isEmpty)) {
                                    return cc.Translations.of(context)
                                        .enter_group_password;
                                  }
                                  return null;
                                },
                                maxLength: 16,
                                onChanged:
                                    createGroupController.onPasswordChange,
                                style: widget.createGroupStyle
                                        .passwordInputTextStyle ??
                                    TextStyle(
                                      color: theme.palette.getAccent(),
                                      fontSize: theme.typography.body.fontSize,
                                      fontFamily:
                                          theme.typography.body.fontFamily,
                                      fontWeight:
                                          theme.typography.body.fontWeight,
                                    ),
                                decoration: InputDecoration(
                                    counterText: '',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: widget.createGroupStyle
                                                  .borderColor ??
                                              theme.palette.getAccent100()),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: widget.createGroupStyle
                                                  .borderColor ??
                                              theme.palette.getAccent100()),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: theme.palette.getAccent100()),
                                    ),
                                    hintText: widget.passwordPlaceholderText ??
                                        cc.Translations.of(context).password,
                                    hintStyle: widget.createGroupStyle
                                            .passwordPlaceholderTextStyle ??
                                        TextStyle(
                                          color: theme.palette.getAccent600(),
                                          fontSize:
                                              theme.typography.body.fontSize,
                                          fontFamily:
                                              theme.typography.body.fontFamily,
                                          fontWeight:
                                              theme.typography.body.fontWeight,
                                        )),
                                keyboardAppearance: theme.palette.mode ==
                                        PaletteThemeModes.light
                                    ? Brightness.light
                                    : Brightness.dark,
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  Widget _buildDayWidget(String day, CreateGroupController controller) {
    return InkWell(
      onTap: () {
        controller.addToSelectedDays(day);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(top: 5.0, right: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          color: controller.selectedDays.contains(day)
              ? Colors.greenAccent
              : Color.fromARGB(255, 226, 239, 249),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _selectAppointmentTime(BuildContext context, controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) controller.getTaskTime(picked);
  }

  Future<void> _selectAppointmentTimeTo(
      BuildContext context, controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) controller.getTaskTimeTo(picked);
  }

  Widget selectTimeWidget(CreateGroupController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "From Time",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding:
                EdgeInsetsDirectional.only(top: 0, bottom: 0, start: 5, end: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            side: BorderSide(color: Colors.grey.withOpacity(.3)),
            primary: Theme.of(context).textTheme.bodyText1?.color,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.timer,
              color: Colors.green,
              size: 15,
            ),
            const SizedBox(
              width: 4,
            ),
            if (controller.time != null)
              Text(
                controller.time.hour.toString() +
                    ":" +
                    controller.time.minute.toString(),
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
          ]),
          onPressed: () {
            _selectAppointmentTime(context, controller);
          },
        ),
      ],
    );
  }

  Widget selectEndTimeWidget(CreateGroupController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To Time",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding:
                EdgeInsetsDirectional.only(top: 0, bottom: 0, start: 5, end: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            side: BorderSide(color: Colors.grey.withOpacity(.3)),
            primary: Theme.of(context).textTheme.bodyText1?.color,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.timer,
              color: Colors.green,
              size: 15,
            ),
            const SizedBox(
              width: 4,
            ),
            if (controller.to_time != null)
              Text(
                controller.to_time.hour.toString() +
                    ":" +
                    controller.to_time.minute.toString(),
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
          ]),
          onPressed: () {
            _selectAppointmentTimeTo(context, controller);
          },
        ),
      ],
    );
  }
}
