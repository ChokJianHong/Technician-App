import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';

class Complete_Job_Details extends StatefulWidget {
  const Complete_Job_Details({super.key});

  @override
  State<Complete_Job_Details> createState() => _Complete_Job_DetailsState();
}

class _Complete_Job_DetailsState extends State<Complete_Job_Details> {
  int _currentIndex = 1;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: Color(0xFF391370),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
          child:  Padding(
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
              Text('Parts Requested',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
             Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AE Sliding Autogate\nRear Rack 1 Meter X3',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '6 Rubber Coupling\nFor Mini Motor X1',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
             ),
             SizedBox(height: 10,),
             Text('Technician: Dylan'),
             SizedBox(height: 10,),
             Text('Payment Method: Cash'),
             SizedBox(height: 10,),
             Text('Amount: RM 257'),
             
            ],),
          ),
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
