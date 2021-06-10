import 'package:flutter/material.dart';
import 'package:presto/ui/widgets/inputTextField.dart';
Widget paymentSheet({
  var height,
  var width,
  required TextEditingController upiController,
  var onCompleteCallBack,
}) {
  return DraggableScrollableSheet(
    initialChildSize: 0.7,
    builder: (context,controller){
      return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(width/15))
      ),
      child: ListView(
        controller: controller,
        children: <Widget>[
          SizedBox(
            height: height / 45,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                  onTap: () {
                    if(upiController.text == ""){
                      print('null aaya');
                    }else{
                      print(upiController.text);
                    }
                    if(onCompleteCallBack!= null)
                      onCompleteCallBack();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: height/45,
                    ),
                  )
              ),
            ),
          ),
          SizedBox(
            height: height / 45,
          ),
          Padding(
            padding: EdgeInsets.all(width / 20),
            child: Text(
              'We will pay you through your contact number, please enter your UPI ID',
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
          ),
          // SizedBox(
          //   height: height / 25,
          // ),
          // Container(
          //   width: width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       PaymentCard(
          //         imagePath: 'assets/images/paytmbox.webp',
          //         index: 1,
          //         callBackToAddInTheOptionInTheList: addToList,
          //         callBackToRemoveInTheOptionInTheList: removeFromList,
          //       ),
          //       SizedBox(width: width/10,),
          //       PaymentCard(
          //         imagePath: 'assets/images/gpaybox.png',
          //         index: 2,
          //         callBackToAddInTheOptionInTheList: addToList,
          //         callBackToRemoveInTheOptionInTheList: removeFromList,
          //       )
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: height/25,
          // ),
          // Container(
          //   width: width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       PaymentCard(
          //         imagePath: 'assets/images/paypalbox.png',
          //         index: 3,
          //         callBackToAddInTheOptionInTheList: addToList,
          //         callBackToRemoveInTheOptionInTheList: removeFromList,
          //       ),
          //       SizedBox(width: width/10,),
          //       PaymentCard(
          //         imagePath: 'assets/images/phonepaybox.png',
          //         index: 4,
          //         callBackToAddInTheOptionInTheList: addToList,
          //         callBackToRemoveInTheOptionInTheList: removeFromList,
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: height/25,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     PaymentCard(
          //       imagePath: 'assets/images/amazonpaybox.png',
          //       index: 5,
          //       callBackToAddInTheOptionInTheList: addToList,
          //       callBackToRemoveInTheOptionInTheList: removeFromList,
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: height/25,
          // ),
          Padding(
            padding: EdgeInsets.all(width/20),
            child: InputField(
              controller: upiController,
              helperText: "Enter your UPI ID",
            ),
          )
        ],
      ),
    );
      },
  );
}