import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_roadi_app/utiles/app_constants.dart';
import 'package:last_roadi_app/utiles/preference.dart';
import 'package:last_roadi_app/utiles/route_helper.dart';
import 'package:last_roadi_app/views/groups/craete_group_screen.dart';
import 'package:last_roadi_app/widgets/custom_snackbar.dart';
import 'package:last_roadi_app/widgets/myappbar.dart';
import 'package:last_roadi_app/widgets/mytext.dart';
// import 'package:cometchat/cometchat.dart';
import 'package:cometchat_sdk/cometchat_sdk.dart';

class GroupsScreen extends StatefulWidget {
  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  String userId = Preference.shared.getString(AppConstants.USER_ID) ?? '';

  List myGroupsList = [];
  List allGroupsList = [];
  @override
  void initState() {
    initializeLists();
    super.initState();
  }

  // Create an async function to initialize your lists.
  void initializeLists() async {
    myGroupsList = await getUserGroups(userId);
    allGroupsList = await allGroups();

    setState(() {
      // You may want to call setState to rebuild your widget with the updated data.
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/bg.webp"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(50.0, 50.0),
                  ),
                ),
              ),
              Column(
                children: [
                  getAppbar(),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      isScrollable: true,
                      // onTap: (index) {
                      //   getData(index: index);
                      // },
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      tabAlignment: TabAlignment.center,
                      padding: EdgeInsets.all(0),
                      labelPadding: EdgeInsets.symmetric(horizontal: 7),
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.white,
                      tabs: [
                        Padding(
                           padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                          child: MyText(
                              title: 'Joined Groups',
                              size: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                           padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                          child: MyText(
                            title: 'All Groups',
                            size: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        myGroupsView(),
                        allGroupsView(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: InkWell(
            customBorder:
                CircleBorder(), // Use this property for a circular shape
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatCreateGroupScreen(),
                ),
              );
            },
            child: Container(
              width: 50, // Adjust the size as needed
              height: 50, // Adjust the size as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Set the shape to circle
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Icon(
                  Icons.edit,
                  color: Colors.white, // Change the icon color as needed
                  size: 30,
                ),
              ),
            ),
          )),
    );
  }

  getAppbar() {
    return MyAppbar(
      title: "Roadi",
      withLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: InkWell(
              onTap: () {
                Get.toNamed(RouteHelper.getSettingsRoute());
              },
              child: Icon(
                Icons.settings,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  myGroupsView() {
    return CometChatGroups(
      title: 'Joined Groups',
      showBackButton: false,
      listItemView: (group) {
        if (group.hasJoined == true) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CometChatMessages(
                    group: group,
                  ),
                ),
              );
            },
            child: CometChatListItem(
              avatarURL: group.icon,
              avatarName: group.name,
              title: group.name,
              tailView: Text("${group.membersCount} members"),
              subtitleView: Text(group.description ?? ''),
            ),
          );
        } else {
          return Container();
        }
      },
      onItemTap: (context, group) {
        if (group.membersCount > 5) {
          showCustomSnackBar("This Group is Full!");
        }
      },
    );
  }

  allGroupsView() {
    return CometChatGroups(
      title: 'All Groups',
      showBackButton: false,
      listItemView: (group) {
        return InkWell(
          onTap: () {
            if (group.membersCount >= 5) {
              showCustomSnackBar("This Group is Full!");
              return;
            } else {
              if (group.hasJoined) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CometChatMessages(
                      group: group,
                    ),
                  ),
                );
              } else if (group.type == GroupTypeConstants.password) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CometChatJoinProtectedGroup(
                      group: group,
                    ),
                  ),
                );
              } else if (group.type == GroupTypeConstants.public) {
                _joinGroup(guid: group.guid, groupType: group.type);
              } else {
                CometChat.joinGroup(group.guid, group.type,
                    onSuccess: (group) {}, onError: (err) {});
              }
            }
          },
          child: CometChatListItem(
            avatarURL: group.icon,
            avatarName: group.name,
            title: group.name,
            tailView: Text("${group.membersCount} members"),
            subtitleView: Text(group.description ?? ''),
          ),
        );
      },
      onItemTap: (context, group) {
        print("object");
        if (group.membersCount >= 5) {
          showCustomSnackBar("This Group is Full!");
          return;
        } else {
          if (group.hasJoined) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CometChatMessages(
                  group: group,
                ),
              ),
            );
          } else if (group.type == GroupTypeConstants.password) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CometChatJoinProtectedGroup(
                  group: group,
                ),
              ),
            );
          } else if (group.type == GroupTypeConstants.public) {
            _joinGroup(guid: group.guid, groupType: group.type);
          } else {
            CometChat.joinGroup(group.guid, group.type,
                onSuccess: (group) {}, onError: (err) {});
          }
        }
      },
    );
  }

  allGroups() async {
    // Get the groups request builder.
    GroupsRequestBuilder groupsRequestBuilder = new GroupsRequestBuilder();

    // Build the groups request.
    GroupsRequest groupsRequest = groupsRequestBuilder.build();

    // Fetch the groups.
    List groups = await groupsRequest.fetchNext(
        onError: (CometChatException excep) {},
        onSuccess: (List<Group> groupList) {});
    print(groups);
    // Return the list of groups.
    return groups;
  }

  getUserGroups(String uid) async {
    // Get the groups request builder.
    GroupsRequestBuilder? groupsRequestBuilder = GroupsRequestBuilder();

    // Build the groups request.
    GroupsRequest groupsRequest = groupsRequestBuilder.build();

    // Fetch the groups for the user.
    List<Group> groups = await groupsRequest.fetchNext(
      onError: (CometChatException excep) {},
      onSuccess: (List<Group> groupList) {},
    );

    // Filter groups where the user has joined.
    List<Group> justMyGroups =
        groups.where((element) => element.hasJoined == true).toList();
    print(justMyGroups);
    // Return the list of groups.
    return justMyGroups;
  }

  _joinGroup(
      {required String guid, required String groupType, String password = ""}) {
    showLoadingIndicatorDialog(context,
        background: Colors.white,
        progressIndicatorColor: Theme.of(context).primaryColor,
        shadowColor: Colors.grey.shade300);

    CometChat.joinGroup(guid, groupType, password: password,
        onSuccess: (Group group) async {
      User? user = await CometChat.getLoggedInUser();
      if (kDebugMode) {
        debugPrint("Group Joined Successfully : $group ");
      }

      if (context.mounted) {
        Navigator.pop(context); //pop loading dialog
      }

      //ToDo: remove after sdk issue solve
      if (group.hasJoined == false) {
        group.hasJoined = true;
      }

      CometChatGroupEvents.ccGroupMemberJoined(user!, group);
    }, onError: (CometChatException e) {
      Navigator.pop(context); //pop loading dialog

      showCometChatConfirmDialog(
          context: context,
          style: ConfirmDialogStyle(
              backgroundColor: Colors.white,
              shadowColor: Colors.grey.shade300,
              confirmButtonTextStyle:
                  TextStyle(color: Theme.of(context).primaryColor)),
          title: Text('Something Went Wrong', style: TextStyle()),
          confirmButtonText: 'okay',
          onConfirm: () {
            Navigator.pop(context); //pop confirm dialog
          });
    });
  }
}
