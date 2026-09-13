enum PaymentGateway {
  googlePay,
  applePay,
  bKash,
  stripeCard,
  payPal,
  upi,
}

class InvoiceLineItem {
  final String title;
  final String subtitle;
  final double amount;

  const InvoiceLineItem({
    required this.title,
    required this.subtitle,
    required this.amount,
  });
}

class InvoiceDetail {
  final String invoiceNumber;
  final String tokenCode;
  final String targetDriveEmail;
  final String rawStorageSize;
  final String masterCapturesCount;
  final String dueDate;
  final List<InvoiceLineItem> lineItems;
  final double taxAmount;
  final double totalUsd;
  final String totalBdt;
  final bool isEscrowLocked;

  const InvoiceDetail({
    required this.invoiceNumber,
    required this.tokenCode,
    required this.targetDriveEmail,
    required this.rawStorageSize,
    required this.masterCapturesCount,
    required this.dueDate,
    required this.lineItems,
    required this.taxAmount,
    required this.totalUsd,
    required this.totalBdt,
    this.isEscrowLocked = true,
  });
}
