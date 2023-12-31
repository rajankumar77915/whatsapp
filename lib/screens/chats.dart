import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String current_page = "Chats"; // default page
  final PageController controller = PageController();
  Widget buildPage(String pageName) {
    return Expanded(
      child: Column(
          children: [

          SizedBox(
            width: double.infinity,
            child:TextButton(
              onPressed: () {
                current_page=pageName;
                controller.animateToPage(
                  _getPageNumber(pageName),
                  duration:const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                setState(() {});
              },
              child:Text(pageName,style:  const TextStyle(fontSize: 19, color: Colors.white),),
            ),
          ),

            ColoredBox(
              color: current_page == pageName ? Colors.white :const  Color(0xFF25D366),
              child: const SizedBox(width: double.infinity, height: 5),
            ),
          ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF25D366),
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("WhatsApp"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined),
                SizedBox(width: 20),
                Icon(Icons.search),
                SizedBox(width: 20),
                Icon(Icons.more_vert),
              ],
            ),
          ],
        ),
      ),
      body:  Column(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(color:  Color(0xFF25D366)),
            child: Column(
              children: [
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildPage("Chats"),
                    buildPage("Status"),
                    buildPage("Calls"),
                  ],
                ),

              ],
            ),
          ),
          Expanded(child:
          PageView(
            controller: controller,
            onPageChanged: (int index) {
              // Update current_page when the page changes
              setState(() {
                switch (index) {
                  case 0:
                    current_page = "Chats";
                    break;
                  case 1:
                    current_page = "Status";
                    break;
                  case 2:
                    current_page = "Calls";
                    break;
                }
              });
            },
            children: const <Widget>[
              Center(
                child: Text('Chats'),
              ),
              Center(
                
                child: Text("status"),
              ),
              Center(
                child: Text('Third Page'),
              ),
            ],
          ),
          )



        ],
      ),
    );
  }
}

int _getPageNumber(String pageName) {
  switch (pageName) {
    case "Chats":
      return 0;
    case "Status":
      return 1;
    case "Calls":
      return 2;
    default:
      return 0;
  }
}