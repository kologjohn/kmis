import 'package:flutter/material.dart';

class SchoolReceipt extends StatefulWidget {
  const SchoolReceipt({super.key});

  @override
  State<SchoolReceipt> createState() => _SchoolReceiptState();
}

class _SchoolReceiptState extends State<SchoolReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f4ff),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          color: Color(0xFF00496d),
                          child: const Center(
                            child: Text(
                              "Logo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              "BOLGA, UPPER EAST",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "INFO@KOLOGSOFT.COM",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "WWW.KOLOGSOFT.COM",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "+233 553 354 349",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 30,
                      color: Color(0xFF00496d),
                    ),
                    const SizedBox(height: 60),
                    const Center(
                      child: Text(
                        "School Fees Receipt",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00496d)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text.rich(
                          TextSpan(
                            text: "Date: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: "January 15, 2050",
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Receipt No.: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: "12345",
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40, color: Color(0xFF00496d),),

                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text.rich(
                              TextSpan(
                                text: "Received From:\n",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: "Yambalga Joseph Yinbey",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text.rich(
                              TextSpan(
                                text: "Payment Type: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: "Cash",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text.rich(
                              TextSpan(
                                text: "Payment for: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: "School Fees for First Term 2050",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey.shade200),
                          children: const [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Description",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Amount (GHC)",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        tableRow("School Fee (First Term 2025)", "2,500.00"),
                        tableRow("Library Fee", "150.00"),
                        tableRow("Sports Fee", "50.00"),
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey.shade100),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Total",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("2,700.00",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text.rich(
                              TextSpan(
                                text: "Payment Method: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: "Credit Card",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text.rich(
                              TextSpan(
                                text: "Payment Date: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: "January 15, 2050",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thank you for your payment. For any further inquiries, please contact us at info@kologsoft.com or call 0553354349.",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow tableRow(String description, String amount) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(description),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(amount),
        ),
      ],
    );
  }
}
