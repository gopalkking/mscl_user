import 'package:flutter/material.dart';
import 'package:mscl_user/View/widgets/my_header_drawer.dart';
import 'package:mscl_user/color.dart';

class ReportsListView extends StatelessWidget {
  const ReportsListView({super.key});

  @override
  Widget build(BuildContext context) {
      
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black), // Ensure the drawer icon is visible
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, AppPageNames.notificationScreen);
                },
                icon: const Icon(
                  Icons.my_location_outlined,
                  size: 30,
                  color: Colors.red,
                ),
                style: IconButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 215, 229, 241),
                    padding: const EdgeInsets.all(8)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Location",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 3.0)]),
              height: 0.8,
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
            
             const MyHeaderDrawer(),
              ListTile(
                title: const Text('Home',style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  // Navigate to Home
                },
              ),
              ListTile(
                title: const Text('My Reports'),
                onTap: () {
                  // Navigate to My Reports
                },
              ),
              ListTile(
           
                title: const Text('Notification'),
                onTap: () {
                  // Navigate to Notification
                },
              ),
              ListTile(
          
                title: const Text('Language'),
                onTap: () {
                  // Navigate to Language
                },
              ),
              ListTile(
      
                title: const Text('About'),
                onTap: () {
                  // Navigate to About
                },
              ),
              ListTile(
        
                title: const Text('Privacy Policy'),
                onTap: () {
                  // Navigate to Privacy Policy
                },
              ),
            ],
          ),
        ),
        body: const Column(
          children: [
             TabBar(
            indicatorColor: maincolor,
            dividerColor: Colors.transparent,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 5,
                color: maincolor,
              )
            ),
            tabs: [
              Tab(child: Text("My Reports",style: TextStyle(color: maincolor,fontSize: 16),),),
              Tab(child:  Text("Closed",style: TextStyle(color: maincolor,fontSize: 16),),),
            ],
          ),
          SizedBox(height: 10,),
            Expanded(
              child: TabBarView(
                children: [
                  ReportsList(tab: 'My Reports'),
                  ClosedList(tab: 'Closed'),
                ],
              ),
            ),
          
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle floating action button press
          },
          backgroundColor: maincolor,
          shape: const CircleBorder(),
          child: const Icon(Icons.feed_outlined,color: Colors.white,size: 30,),
        ),
      ),
    );
  }
}

class ReportsList extends StatelessWidget {
  final String tab;
  const ReportsList({required this.tab, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 6, 
      itemBuilder: (context, index) {
        return ReportItem(
          status: _getStatus(index),
          statusLabel: _getStatusLabel(index),
        );
      },
    );
  }

  String _getStatus(int index) {
    switch (index) {
      case 0:
        return 'New';
      case 1:
        return 'In Progress';
      case 2:
        return 'On Hold';
      case 3:
        return 'Resolved';
      case 4:
        return 'On Hold';
      case 5:
        return 'In Progress';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusLabel(int index) {
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class ReportItem extends StatelessWidget {
  final String status;
  final Color statusLabel;

  const ReportItem({
    required this.status,
    required this.statusLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Street light hanging",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Complaint no: #468674',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  "According to witnesses, the street light began to tilt and eventually started hanging after a recent",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                     const Text(
                  "5 days ago",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 65,),
                   Container(padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                   decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                   ),
                   child: const Text("Status",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 8),),
                   ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusLabel,
                        
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Image.asset(
            "assets/images/myreports.png",
            width: 107.0,
            height: 115.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}



class ClosedList extends StatelessWidget {
  final String tab;
  const ClosedList({required this.tab, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 6, 
      itemBuilder: (context, index) {
        return const Closed();
      },
    );
  }
}

class Closed extends StatelessWidget {
 

  const Closed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Street light hanging",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Complaint no: #468674',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  "According to witnesses, the street light began to tilt and eventually started hanging after a recent",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                     const Text(
                  "5 days ago",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 65,),
                   Container(padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                   decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                   ),
                   child: const Text("Status",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 8),),
                   ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 63, 91, 1),
                        
                      ),
                      child: const Text(
                        "Closed",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Image.asset(
            "assets/images/myreports.png",
            width: 107.0,
            height: 115.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
