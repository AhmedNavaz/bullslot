import 'package:bullslot/models/bankAccount.dart';
import 'package:flutter/material.dart';
import '../../../../models/product.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen(
      {super.key, this.product, this.bookedCount, this.deliveryCharges});

  Product? product;
  int? bookedCount;
  int? deliveryCharges;

  List<BankAccount> bankAccounts = [
    BankAccount(
      id: '1',
      accountName: 'Bullslot',
      accountNumber: '1234567890',
      bankName: 'HDFC',
      bankAddress: 'Mumbai',
      currency: 'INR',
    ),
    BankAccount(
      id: '2',
      accountName: 'Bullslot',
      accountNumber: '1234567890',
      bankName: 'HDFC',
      bankAddress: 'Mumbai',
      currency: 'INR',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Checkout',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Account Details',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.black, fontSize: 26),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bankAccounts.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey.shade200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Account # ${index + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Account Name',
                              style: Theme.of(context).textTheme.bodyText1),
                          const Spacer(),
                          Text(bankAccounts[index].accountName!,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Bank Name',
                              style: Theme.of(context).textTheme.bodyText1),
                          const Spacer(),
                          Text(bankAccounts[index].bankName!,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Bank Address',
                              style: Theme.of(context).textTheme.bodyText1),
                          const Spacer(),
                          Text(bankAccounts[index].bankAddress!,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Account Number',
                              style: Theme.of(context).textTheme.bodyText1),
                          const Spacer(),
                          Text(bankAccounts[index].accountNumber!,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Currency',
                              style: Theme.of(context).textTheme.bodyText1),
                          const Spacer(),
                          Text(bankAccounts[index].currency!,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            ListTile(
              title: Text('Delivery Charges',
                  style: Theme.of(context).textTheme.bodyText1),
              trailing: Text(
                '\$${deliveryCharges?.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text('Subtotal (${bookedCount.toString()}x slots)',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18)),
              trailing: Text(
                '\$${product!.totalPrice! / product!.totalSlots! * bookedCount!}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 0,
              indent: 10,
              endIndent: 10,
              color: Colors.grey.shade400,
            ),
            ListTile(
              title:
                  Text('Total', style: Theme.of(context).textTheme.bodyText1),
              trailing: Text(
                '\$${product!.totalPrice! / product!.totalSlots! * bookedCount! + deliveryCharges!}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Text(
              'Pay the above amount in one of our bank accounts and then click on the below button.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'I\'ve Paid',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
