import 'package:flutter/material.dart';

import 'invoice.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({super.key});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final industryNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final gstNumberCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -15,
        title: const Text(
          'Customer Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.indigo]),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Industry Name', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              _buildTextField(
                controller: industryNameCtrl,
                hint: "Enter Your Industry Name",
                validator: (v) =>
                    v!.isEmpty ? "Please enter Industry name" : null,
              ),
              Text('Address', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              _buildTextField(
                controller: addressCtrl,
                hint: "Enter Your Address",
                validator: (v) =>
                    v!.isEmpty ? "Please enter your Address" : null,
              ),
              Text('Phone Number', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              _buildTextField(
                controller: phoneCtrl,
                hint: "Enter Your Phone Number",
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v!.isEmpty ? "Please enter your Phone Number" : null,
              ),
              Text('GST Number', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              _buildTextField(
                controller: gstNumberCtrl,
                hint: "Enter Your GST Number",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Please enter Your GST Number" : null,
              ),
              Text('State', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              _buildTextField(
                controller: stateCtrl,
                hint: "Enter Your State",
                validator: (v) => v!.isEmpty ? "Please enter your State" : null,
              ),
              Text('Amount', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              _buildTextField(
                controller: amountCtrl,
                hint: "Enter Your Amount",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Please enter your Amount" : null,
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.indigo],
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfReceiptPage(
                            industryName: industryNameCtrl.text,
                            address: addressCtrl.text,
                            phone: phoneCtrl.text,
                            gstNumber: gstNumberCtrl.text,
                            state: stateCtrl.text,
                            amount: amountCtrl.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Generate Receipt",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    ),
  );
}
