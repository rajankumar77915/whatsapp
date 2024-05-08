class Status {
  final List<String> statusType;
  final String status;

  Status({required this.statusType, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'statusType': statusType,
      'status': status,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      statusType: List<String>.from(map['statusType']),
      status: map['status'],
    );
  }
}