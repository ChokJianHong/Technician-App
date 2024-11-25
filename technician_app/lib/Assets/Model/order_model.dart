// ignore_for_file: file_names

class OrderModel {
  final int orderId;
  final int customerId;
  final String orderDate;
  final String? orderDoneDate;
  final String orderTime;
  final String orderStatus;
  final String orderDetail;
  final String orderImg;
  final String? orderDoneImg;
  final String urgencyLevel;
  final String problemType;
  final int? technicianId;
  final DateTime? technicianEta;
  final String? cancelDetails;
  final String locationDetails;
  final String priceDetails;
  final String priceStatus;
  final int? totalPrice;
  final int accept;
  final DateTime createAt;

  final String? customerName;
  final String? customerLocation;
  final String? autoGateBrand;
  final String? alarmBrand;

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.orderDate,
    required this.orderDoneDate,
    required this.orderTime,
    required this.orderStatus,
    required this.orderDetail,
    required this.orderImg,
    required this.orderDoneImg,
    required this.urgencyLevel,
    required this.problemType,
    required this.technicianId,
    required this.technicianEta,
    required this.cancelDetails,
    required this.locationDetails,
    required this.priceDetails,
    required this.priceStatus,
    required this.totalPrice,
    required this.accept,
    required this.createAt,
    this.customerName,
    this.customerLocation,
    this.autoGateBrand,
    this.alarmBrand,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      orderDate: json['order_date'] ?? '',
      orderDoneDate: json['order_done_date'],
      orderTime: json['order_time'] ?? '',
      orderStatus: json['order_status'] ?? '',
      orderDetail: json['order_detail'] ?? '',
      orderImg: json['order_img'] ?? '',
      orderDoneImg: json['order_done_img'],
      urgencyLevel: json['urgency_level'] ?? '',
      problemType: json['problem_type'] ?? '',
      technicianId: json['technician_id'],
      createAt: json['create_at'] != null
          ? DateTime.parse(json['create_at']) 
          : DateTime.now(),
      technicianEta: json['technician_eta'] != null
          ? DateTime.parse(json['technician_eta'])
          : null,
      cancelDetails: json['cancel_details'],
      locationDetails: json['location_details'] ?? '',
      priceDetails: json['price_details'] ?? '',
      priceStatus: json['price_status'] ?? '',
      totalPrice: json['total_price'] ?? 0,
      accept: json['accept'] ?? 0,
      customerName: json['customer_name'],
      customerLocation: json['customer_location'],
      autoGateBrand: json['auto_gate_brand'],
      alarmBrand: json['alarm_brand'],
    );
  }
}
