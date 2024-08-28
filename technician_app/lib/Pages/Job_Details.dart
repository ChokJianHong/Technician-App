import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {

  int _currentIndex = 1;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF391370),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    Text('226A, Jalan Abdul Razak, 93200, Kuching Sarawak',style: TextStyle(fontSize: 15),),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Brand',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              Text('Eden Robot',style: TextStyle(fontSize: 15),)
                            ],
                          ),
                          SizedBox(width: 115,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text('Model',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            Text('eGate X1 Mini',style: TextStyle(fontSize: 15),)
                          ],)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              Text('16 March 2024',style: TextStyle(fontSize: 15),)
                            ],
                          ),
                          SizedBox(width: 90,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text('Time',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            Text('4:30PM',style: TextStyle(fontSize: 15),)
                          ],)
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('Description of the Problem',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    SizedBox(height: 10,),
                    TextField(
                      maxLines: 3,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: 'There is no response of the autogate working',
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF42CE30)),onPressed: () {}, child: Text('Order Complete',style: TextStyle(color: Colors.white),)),
                          SizedBox(height: 10,),
                          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD02B2B)),onPressed: () {}, child: Text('Cancel Request',style: TextStyle(color: Colors.white),)),
                          SizedBox(height: 10,),
                          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3795BD)),onPressed: () {}, child: Text('Part Request',style: TextStyle(color: Colors.white),)),
                          SizedBox(height: 10,),
                          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4E31AA)),onPressed: () {}, child: Text('Start Request',style: TextStyle(color: Colors.white),)),
                        ],
                      ),
                    ),
            ],),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}