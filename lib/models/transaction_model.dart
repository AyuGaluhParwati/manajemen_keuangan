class TransactionModel {
  int? id;
  String title;
  double amount;
  String type; // income / expense
  String category;
  String note;
  String date;
  String? receipt;
  String createdAt;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.note,
    required this.date,
    this.receipt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'note': note,
      'date': date,
      'receipt': receipt,
      'created_at': createdAt,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'] is int
          ? (map['amount'] as int).toDouble()
          : map['amount'],
      type: map['type'],
      category: map['category'],
      note: map['note'],
      date: map['date'],
      receipt: map['receipt'],
      createdAt: map['created_at'],
    );
  }
}