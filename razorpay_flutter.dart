import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motomap_admin/models/plan/subscription_plans_model.dart';
import 'package:motomap_admin/repository/api_repository.dart';
import 'package:motomap_admin/utils/resposive.dart';
import 'package:motomap_admin/utils/utils.dart';

class PlanWidget extends StatefulWidget {
  final List<Result> subcriptions;
  final bool isUpgrade;
  const PlanWidget({
    super.key,
    required this.subcriptions,
    required this.isUpgrade,
  });

  @override
  State<PlanWidget> createState() => _PlanWidgetState();
}

class _PlanWidgetState extends State<PlanWidget> {
  int userPlan = 1;
  List<Result> userSubsList = [];
  List userPlanList = [];
  int currentIndex = 0;
  int initialIndex = 0;
  Map? selectedPlan;
  late Razorpay razorpay;

  @override
  void initState() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    userPlan = int.parse(currentPlan!.planDetails.subPlan);
    // userPlan = int.parse(currentPlan!.planDetails.subPlan);
    debugPrint(currentPlan!.planDetails.subPlan);
    initialIndex = userPlan - 1;
    debugPrint(widget.isUpgrade.toString() + " bool");

    filterPlans(widget.isUpgrade);

    super.initState();
  }

  filterPlans(bool isUpgrade) {
    userSubsList = [];
    userPlanList = [];
    userSubsList = widget.subcriptions;
    userPlanList = plan;
    // if (isUpgrade) {
    //   for (var i = initialIndex; i < widget.subcriptions.length; i++) {
    //     userSubsList.add(widget.subcriptions[i]);
    //     userPlanList.add(plan[i]);
    //     debugPrint(userSubsList.toString());
    //   }
    // } else {
    //   userSubsList = widget.subcriptions;
    //   userPlanList = plan;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Perfect Plan For You",
            textScaleFactor: 1.25,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          CarouselSlider.builder(
            itemCount: userSubsList.length,
            // itemCount: widget.subcriptions.length,
            itemBuilder: (context, index, realIndex) {
              currentIndex = index;

              return planCard(index);
            },
            options: CarouselOptions(
              initialPage: initialIndex,
              autoPlay: false,
              viewportFraction: isTablet() ? .45 : .58,
              enlargeCenterPage: true,
              enlargeFactor: .15,
              aspectRatio: isTablet() ? 1.4 : 1,
              enableInfiniteScroll: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget planCard(int index) {
    final subscription = userSubsList[index];
    int remainingDays = getRemainingDays(currentPlan!.planDetails.planEndDate);
/////////////////////////////////////////////////////////
    double currentUserPrice = currentUserPlanPrice(
        int.parse(activePlanId),
        int.parse(userPlanList[index]['plan_id']),
        remainingDays,
        double.parse(userPlanList[index]['price']),
        currentPlanPrice(currentPlan!.planDetails.subPlan));
//////////////////////////////////////////////////////
    String price = formatDouble(currentUserPrice);
    return Card(
      color: currentIndex == index ? Colors.grey.shade100 : Colors.grey,
      // color: Colors.white,
      // color: colorPayCard,
      child: Container(
        padding: const EdgeInsets.only(left: 35, right: 10),
        height: 500,
        width: 300,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customText(subscription.plans, 1.5),
            const SizedBox(height: 16),
            index != 0
                ? Text(
                    "₹${userPlanList[index]['crossprice']}/Month",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontFamily: "Roboto",
                    ),
                    softWrap: true,
                    textScaleFactor: 1.3,
                  )
                : const SizedBox.shrink(),
            Text(
              "₹$price/Month",
              style: const TextStyle(
                fontFamily: "Roboto",
              ),
              softWrap: true,
              textScaleFactor: 1.3,
            ),
            const SizedBox(height: 16),
            customText("${userPlanList[index]['adcount']} Listing Counts", .9),
            const SizedBox(height: 4),
            customText(
                "${userPlanList[index]['advisibilty']} Days Ad visibility", .9),
            const SizedBox(height: 4),
            customText("${userPlanList[index]['testdrives']} Test drives", .9),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  userPlanList[index]['customerchat'] == "1"
                      ? Icons.check_circle_outline
                      : Icons.close_rounded,
                  size: 17,
                  color: userPlanList[index]['customerchat'] == "1"
                      ? Colors.green
                      : Colors.red,
                ),
                customText(" Customer chat", .9),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  userPlanList[index]['notifications'] == "1"
                      ? Icons.check_circle_outline
                      : Icons.close_rounded,
                  size: 17,
                  color: userPlanList[index]['notifications'] == "1"
                      ? Colors.green
                      : Colors.red,
                ),
                customText(" Notifications", .9),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  userPlanList[index]['adshare'] == "1"
                      ? Icons.check_circle_outline
                      : Icons.close_rounded,
                  size: 17,
                  color: userPlanList[index]['adshare'] == "1"
                      ? Colors.green
                      : Colors.red,
                ),
                customText(" Ad share option", .9),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  userPlanList[index]['insights'] == "1"
                      ? Icons.check_circle_outline
                      : LineIcons.timesCircle,
                  size: 17,
                  color: userPlanList[index]['insights'] == "1"
                      ? Colors.green
                      : Colors.red,
                ),
                customText(" Business insights", .9),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  userPlanList[index]['businesscenter'] == "1"
                      ? Icons.check_circle_outline
                      : LineIcons.timesCircle,
                  size: 17,
                  color: userPlanList[index]['businesscenter'] == "1"
                      ? Colors.green
                      : Colors.red,
                ),
                customText(" Business Center", .9),
              ],
            ),
            const SizedBox(height: 16),
            userPlanList[index]['plan_id'] != "1"
                ? SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        onPurchase(
                            double.parse(price),
                            userPlanList[index]['plan_id'],
                            userId!,
                            userName ?? "",
                            userMobile ?? "");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subscription.subscrId == activePlanId
                            ? Colors.orange.shade600
                            : Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                      ),
                      child: Text(subscription.subscrId == activePlanId
                          ? "Renew"
                          : "Purchase"),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////////////
  Text customText(text, scaleFactor) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black),
      textScaleFactor: scaleFactor,
    );
  }
////////////////////////////////////////////////////////////////////////////////////////

  List plan = [
    {
      "plan_id": "1",
      "name": "Freedom",
      "price": "0",
      "crossprice": "0",
      "adcount": "10",
      "advisibilty": "30",
      "testdrives": "5",
      "customerchat": "1",
      "notifications": "1",
      "adshare": "1",
      "insights": "0",
      "businesscenter": "0",
    },
    {
      "plan_id": "2",
      "name": "Standard",
      "price": "199",
      "crossprice": "399",
      "adcount": "40",
      "advisibilty": "30",
      "testdrives": "30",
      "customerchat": "1",
      "notifications": "1",
      "adshare": "1",
      "insights": "0",
      "businesscenter": "0",
    },
    {
      "plan_id": "3",
      "name": "Business",
      "price": "249",
      "crossprice": "499",
      "adcount": "60",
      "advisibilty": "30",
      "testdrives": "30",
      "customerchat": "1",
      "notifications": "1",
      "adshare": "1",
      "insights": "1",
      "businesscenter": "0",
    },
    {
      "plan_id": "4",
      "name": "Enterprise",
      "price": "499",
      "crossprice": "999  ",
      "adcount": "Unlimited",
      "advisibilty": "30",
      "testdrives": "Unlimited",
      "customerchat": "1",
      "notifications": "1",
      "adshare": "1",
      "insights": "1",
      "businesscenter": "1",
    },
  ];
  ///////////////////////////////////////////////////////////////////////////////////
  payNow(
    double amount,
    String dealerName,
    String mobile,
  ) {
    const razorPayKey = 'rzp_live_8OMrnlGLeME1Rr';
    // final cartProvider = context.read<ProviderCart>();
    // double amount = cartProvider.cartTotal + cartProvider.deliveryCharge;
    var options = {
      'key': razorPayKey,
      'amount': amount * 100,
      'name': dealerName, "currency": "INR",
      // 'description': 'Fine T-Shirt',
      'prefill': {'contact': mobile, 'email': 'test@razorpay.com'}
    };

    razorpay.open(options);
  }
////////////////////////////////////////////////////////////////////////////////////////

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    debugPrint("success");

    // ApiRepository().storePyamentDetails(companyId: userId, orderId: response.orderId, paymentId:response. paymentId, amountPaid: , newPlanId: newPlanId)
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    debugPrint("payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    debugPrint("payment external wallet");
  }

////////////////////////////////////////////////////////////////////////////////////////
  onPurchase(double amount, String planId, String companyId, String companyName,
      String mobile) async {
    debugPrint(amount.toString() + " amount");
    debugPrint(planId.toString() + " planId");
    debugPrint(companyId.toString() + " companyId");
    debugPrint(companyName.toString() + " companyName");
    debugPrint(mobile.toString() + " mobile");
    payNow(amount, companyName, mobile);
  }
////////////////////////////////////////////////////////////////////////////////////////

  double currentUserPlanPrice(int currentPlanId, int newPlanId,
      int remainingDays, double newPlanPrice, double currentPlanPrice) {
    // debugPrint(newPlanPrice.toString());
    // debugPrint(currentPlanPrice.toString());
    // debugPrint(currentPlanId.toString());
    // debugPrint(newPlanId.toString());
    debugPrint("---------------------------");
    if (newPlanId > currentPlanId) {
      if (remainingDays < 1) {
        return newPlanPrice;
      } else {
        double currentPlanPricePerDay = currentPlanPrice / 30;

        double remainingDaysAmount = currentPlanPricePerDay * remainingDays;
        double amount = newPlanPrice - remainingDaysAmount;
        // debugPrint(currentPlanPricePerDay.toString() + " perv day");
        // debugPrint(remainingDays.toString() + " remaining day");
        // debugPrint(remainingDaysAmount.toString() + " remaining days amount");
        // debugPrint(amount.toString() + " amt");
        // debugPrint("****************************************");
        return amount;
      }
    } else {
      return newPlanPrice;
    }
  }

  ////////////////////////////////////////////
  int getRemainingDays(DateTime planEndDate) {
    debugPrint(planEndDate.toString());
    final now = DateTime.now();
    int expiresIn = planEndDate.difference(now).inDays;
    return expiresIn;
  }

  /////////////////////////////////////
  double currentPlanPrice(String planId) {
    if (planId == "1") {
      return 0;
    } else if (planId == "2") {
      return 199;
    } else if (planId == "3") {
      return 249;
    } else {
      return 499;
    }
  }

  ////////////////////////////////////////////////////////////
  String formatDouble(double value) {
    String formattedValue = value.toStringAsFixed(2).toString();
    if (formattedValue.contains('.') && formattedValue.endsWith('0')) {
      formattedValue = formattedValue.replaceAll(RegExp(r'0*$'), '');
    }
    if (formattedValue.endsWith('.')) {
      formattedValue = formattedValue.substring(0, formattedValue.length - 1);
    }
    return formattedValue;
  }

// Usage:
  // double currentUserPrice = 12.3450;
  // String formattedPrice = formatDouble(currentUserPrice);
}
