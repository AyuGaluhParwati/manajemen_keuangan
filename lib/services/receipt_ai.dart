class ReceiptAI {
  static Map<String, String> parse(String text) {
    String merchant = "";
    String amount = "";
    String date = "";

    // ===========================
    // Ambil Merchant
    // ===========================
    final lines = text.split("\n");

    if (lines.isNotEmpty) {
      merchant = lines.first.trim();
    }

    // ===========================
    // Ambil Nominal
    // ===========================
    final amountRegex = RegExp(
      r'(\d{1,3}(?:[.,]\d{3})+)',
    );

    final amountMatch = amountRegex.firstMatch(text);

    if (amountMatch != null) {
      amount = amountMatch.group(0)!;
      amount = amount.replaceAll(".", "");
      amount = amount.replaceAll(",", "");
    }

    // ===========================
    // Ambil Tanggal
    // ===========================
    final dateRegex = RegExp(
      r'(\d{2}[/-]\d{2}[/-]\d{4})',
    );

    final dateMatch = dateRegex.firstMatch(text);

    if (dateMatch != null) {
      date = dateMatch.group(0)!;
    }

    return {
      "merchant": merchant,
      "amount": amount,
      "date": date,
    };
  }
}