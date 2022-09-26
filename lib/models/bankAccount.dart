class BankAccount {
  String? id;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? bankAddress;
  String? currency;

  BankAccount({
    this.id,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.bankAddress,
    this.currency,
  });

  BankAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountName = json['accountName'];
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    bankAddress = json['bankAddress'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountName'] = this.accountName;
    data['accountNumber'] = this.accountNumber;
    data['bankName'] = this.bankName;
    data['bankAddress'] = this.bankAddress;
    data['currency'] = this.currency;
    return data;
  }
}
