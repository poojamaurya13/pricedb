// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, non_constant_identifier_names, deprecated_member_use, use_key_in_widget_constructors, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_network/image_network.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/screens/homepage.dart';
import 'package:pricedb/screens/setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

User? user = FirebaseAuth.instance.currentUser;

class DatabaseManager {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection("Users");

  Future<void> createUser(
      String uid, String number, String email, String password) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Login details")
        .doc("1")
        .set({'Number': number, 'Email': email, 'Password': password});
  }

  Future getProductList() async {
    List itemsList = [];
    final FireAuth1 object = FireAuth1();
    String uuid = await object.getUserId();

    try {
      await productList.doc(uuid).collection("Product detail").get().then(
            (querySnapshot) => querySnapshot.docs.forEach(
              (element) {
                itemsList.add(element.data());
              },
            ),
          );
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

Widget button(
    {double? height, double? width, Function()? onpressed, Widget? child}) {
  return SizedBox(
    height: height,
    width: width,
    child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color.fromARGB(255, 65, 105, 119),
        onPressed: onpressed,
        child: child),
  );
}

PreferredSizeWidget? appbar(
    {String? text, List<Widget>? actions, PreferredSizeWidget? bottom}) {
  return AppBar(
    elevation: 0.0,
    title: Text(
      text ?? "",
      style: TextStyle(
        fontSize: 13.0.sp,
      ),
    ),
    bottom: bottom,
    actions: actions,
  );
}

Widget productlisttile(
    {required String img,
    String? title,
    String? qua,
    String? price,
    String? finalprice,
    Widget? trailing,
    required Function() onLongPress,
    Function()? ontap}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
    child: ListTile(
      onLongPress: onLongPress,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: const Color.fromARGB(255, 239, 240, 239),
      leading: isChecked
          ? Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 13.h,
              width: 13.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
              child: imewidget(img: img))
          : null,
      title: Text(
        title ?? "",
        style: TextStyle(
            color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (isChecked1 || isChecked2)
              ? Row(
                  children: <Widget>[
                    Text(
                      isChecked1 ? qua ?? "" : "",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 120, 120, 120),
                          fontWeight: FontWeight.w400),
                    ),
                    isChecked1
                        ? qua != null
                            ? SizedBox(
                                width: 3.w,
                              )
                            : Container()
                        : Container(),
                    Text(
                      isChecked2 ? price ?? "" : "",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 120, 120, 120),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              : Text(
                  isChecked3 ? finalprice ?? "" : "",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 120, 120, 120),
                      fontWeight: FontWeight.w400),
                ),
          (isChecked1 || isChecked2) && isChecked3
              ? SizedBox(
                  height: 0.5.h,
                )
              : SizedBox(
                  height: 0.0.h,
                ),
          Text(
            (isChecked1 || isChecked2) && isChecked3 ? finalprice ?? "" : "",
            style: const TextStyle(
                color: Color.fromARGB(255, 120, 120, 120),
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
      trailing: trailing,
      onTap: ontap,
    ),
  );
}

Widget textfield(
    {double? cursorHeight,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String? hinttext,
    TextStyle? style,
    EdgeInsetsGeometry? contentPadding}) {
  return TextFormField(
    cursorHeight: 4.0.h,
    cursorColor: const Color.fromARGB(255, 65, 105, 119),
    controller: controller,
    focusNode: focusNode,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: validator,
    style: style,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: contentPadding,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 65, 105, 119),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 65, 105, 119),
        ),
      ),
      hintText: hinttext ?? "",
      hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    ),
  );
}

void showSelectionDialog(
    {required BuildContext context,
    Function()? gallery,
    Function()? camera}) async {
  double deviseWidth = MediaQuery.of(context).size.width;

  await showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Select photo'),
      children: <Widget>[
        SimpleDialogOption(
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 65, 105, 119),
                ),
                SizedBox(
                  width: deviseWidth * 0.02,
                ),
                const Text('From gallery'),
              ],
            ),
            onPressed: gallery),
        SimpleDialogOption(
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 65, 105, 119),
                ),
                SizedBox(
                  width: deviseWidth * 0.02,
                ),
                const Text('Take a photo'),
              ],
            ),
            onPressed: camera),
      ],
    ),
  );
}

Future<void> alert(
    {required BuildContext context, String? text, Function()? ontap}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(text ?? ""),
              SizedBox(height: 3.h),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: ontap,
                      child: const Text("Yes"),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> delete_alert(
    {required BuildContext context, Function()? ontap}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 1.h,
                width: 100.w,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                    color: Color.fromARGB(255, 200, 17, 4)),
              ),
              Container(
                  height: 20.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color.fromARGB(255, 200, 17, 4),
                          width: 3)),
                  child: Icon(Icons.delete_sweep,
                      size: 5.h, color: const Color.fromARGB(255, 200, 17, 4))),
              Text(
                "Are you sure?",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Do you want to delete this details? Once",
                style: TextStyle(
                    color: const Color.fromARGB(255, 132, 132, 132),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                "deleted cannot be recovered.",
                style: TextStyle(
                    color: const Color.fromARGB(255, 132, 132, 132),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  button(
                      height: 6.h,
                      width: 35.w,
                      onpressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancle",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    height: 6.h,
                    width: 35.w,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: const Color.fromARGB(255, 200, 17, 4),
                        onPressed: ontap,
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      );
    },
  );
}

Widget imagecontainer({Widget? child}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
        clipBehavior: Clip.antiAlias,
        height: 15.h,
        width: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color.fromARGB(233, 222, 238, 246),
        ),
        child: child),
  );
}

Widget imewidget({required String img}) {
  return ImageNetwork(
    onError: const Icon(
      Icons.error,
      color: Color.fromARGB(255, 242, 20, 4),
    ),
    height: 15.h,
    image: img,
    width: 30.w,
    onLoading: const CircularProgressIndicator(
      color: Color.fromARGB(255, 65, 105, 119),
      strokeWidth: 2.0,
    ),
  );
}

Widget logintextforfield(
    {TextEditingController? controller,
    String? hintText,
    Widget? prefixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
    child: TextFormField(
      cursorColor: const Color.fromARGB(255, 65, 105, 119),
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 65, 105, 119),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 65, 105, 119),
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    ),
  );
}

Widget login_buttons(
    {double? height, double? width, Function()? onPressed, String? text}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    height: height,
    width: width,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
    child: RaisedButton(
      color: const Color.fromARGB(255, 65, 105, 119),
      onPressed: onPressed,
      child: Text(
        text ?? "",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget checkboxwidget(
    {String? text,
    String? text1,
    required bool selected,
    required bool selected1,
    Function(bool?)? onChanged,
    Function(bool?)? onChanged1}) {
  return FittedBox(
    child: Row(
      children: <Widget>[
        SizedBox(
          height: 10.h,
          width: 55.w,
          child: CheckboxListTile(
              dense: true,
              title: Text(text ?? ""),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color.fromARGB(255, 65, 105, 119),
              checkColor: const Color.fromARGB(255, 243, 242, 234),
              selected: selected,
              value: selected,
              onChanged: onChanged),
        ),
        SizedBox(
          height: 10.h,
          width: 40.w,
          child: CheckboxListTile(
              dense: true,
              title: Text(text1 ?? ""),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color.fromARGB(255, 65, 105, 119),
              checkColor: const Color.fromARGB(255, 243, 242, 234),
              selected: selected1,
              value: selected1,
              onChanged: onChanged1),
        ),
      ],
    ),
  );
}

Widget settingchecked({
  String? text,
  Function(bool?)? onChanged,
  required bool selected,
}) {
  return CheckboxListTile(
      title: Text(text ?? ""),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color.fromARGB(255, 65, 105, 119),
      checkColor: const Color.fromARGB(255, 243, 242, 234),
      selected: selected,
      value: selected,
      onChanged: onChanged);
}

Future<void> ischeckedpdf() async {
  final prefs1 = await SharedPreferences.getInstance();
  cname = prefs1.getBool('cname') ?? true;
  cnumber = prefs1.getBool('cnumber') ?? true;
  pname = prefs1.getBool('pname') ?? true;
  qty = prefs1.getBool('qty') ?? true;
  fprice = prefs1.getBool('fprice') ?? true;
  price = prefs1.getBool('price') ?? true;
}

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  const AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  });
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  var index1 = 0;
  String Pdf = "ListPDF";
  String gridpdf = "GridPDF";
  String excel = "Excel";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: <Widget>[
          Container(
            width: 100.w,
            height: 7.h,
            decoration: ShapeDecoration(
              color: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                widget.values.length,
                (index) => InkWell(
                  onTap: () {
                    if (widget.values[index] == Pdf) {
                      index1 = 0;
                    } else if (widget.values[index] == gridpdf) {
                      index1 = 1;
                    } else if (widget.values[index] == excel) {
                      index1 = 2;
                    }
                    widget.onToggleCallback(index1);
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xAA000000),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment: index1 == 0
                ? Alignment.centerLeft
                : index1 == 1
                    ? Alignment.center
                    : index1 == 2
                        ? Alignment.centerRight
                        : Alignment.center,
            child: Container(
              width: 25.w,
              height: 7.h,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                index1 == 0
                    ? widget.values[0]
                    : index1 == 1
                        ? widget.values[1]
                        : index1 == 2
                            ? widget.values[2]
                            : widget.values[1],
                style: TextStyle(
                  fontSize: 13.sp,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}

class popupProvider with ChangeNotifier {
  Future<void> checkbox(bool? checked) async {
    cname = checked!;
    final prefs1 = await SharedPreferences.getInstance();
    await prefs1.setBool('cname', checked);
    notifyListeners();
  }

  Future<void> checkbox1(bool? checked1) async {
    cnumber = checked1!;
    final prefs1 = await SharedPreferences.getInstance();
    await prefs1.setBool('cnumber', checked1);
    notifyListeners();
  }

  Future<void> checkbox2(bool? checked2) async {
    pname = checked2!;
    final prefs1 = await SharedPreferences.getInstance();
    await prefs1.setBool('pname', checked2);
    notifyListeners();
  }

  Future<void> checkbox3(bool? checked3) async {
    qty = checked3!;
    final prefs1 = await SharedPreferences.getInstance();
    await prefs1.setBool('qty', checked3);
    notifyListeners();
  }

  Future<void> checkbox4(bool? checked4) async {
    fprice = checked4!;
    final prefs1 = await SharedPreferences.getInstance();
    await prefs1.setBool('fprice', checked4);
    notifyListeners();
  }

  Future<void> checkbox5(bool? checked5) async {
    price = checked5!;
    final prefs1 = await SharedPreferences.getInstance();
    await prefs1.setBool('price', checked5);
    notifyListeners();
  }
}

class LognpressedProvider with ChangeNotifier {
  islongpressfalse(String? id) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Product detail")
        .where("bool", isEqualTo: true)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({"bool": false});
      }
    });
    islongpressed = false;
    notifyListeners();
  }

  islongpresstrue() {
    islongpressed = true;
    notifyListeners();
  }
}

Future pdfname(
    {String? title,
    String? text,
    required void Function()? onPressed,
    required BuildContext context,
    TextEditingController? controller}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$text $title",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: const Color.fromARGB(255, 65, 105, 119)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          size: 30, color: Color.fromARGB(255, 182, 182, 182)),
                      onPressed: () {
                        Navigator.pop(context);
                        controller!.clear();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "Enter the name of the $title file you want to $text",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      color: const Color.fromARGB(255, 103, 102, 102)),
                ),
                SizedBox(height: 1.h),
                textfield(
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  controller: controller,
                  cursorHeight: 25,
                ),
                SizedBox(height: 10.h),
                button(
                  height: 6.h,
                  width: 35.w,
                  onpressed: onPressed,
                  child: Text(
                    text ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class WaveShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var p = Path();
    p.lineTo(0, 0);
    p.cubicTo(width * 1 / 2, 0, width * 2 / 4, height, width, height);
    p.lineTo(width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class BottomWaveShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var p = Path();
    p.lineTo(0, 0);
    p.cubicTo(width * 0 / 2, 0, width * 1 / 4, height, width * 3 / 4, height);
    p.lineTo(0, height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
