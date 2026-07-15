class TransactionModel {
  int? id;

  String title;

  double amount;

  String type;

  String category;

  String merchant;

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
    required this.merchant,
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
      'merchant': merchant,
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
      amount: (map['amount'] as num).toDouble(),
      type: map['type'],
      category: map['category'],
      merchant: map['merchant'] ?? '',
      note: map['note'] ?? '',
      date: map['date'],
      receipt: map['receipt'],
      createdAt: map['created_at'],
    );
  }
}