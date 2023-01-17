// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class Policy_privacy extends StatefulWidget {
  const Policy_privacy({Key? key}) : super(key: key);

  @override
  State<Policy_privacy> createState() => _Policy_privacyState();
}

class _Policy_privacyState extends State<Policy_privacy> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context,'/HomePage');
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Privacy Policy",
            style: TextStyle(fontSize: 13.sp, color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                textheading(text: "Privacy Policy"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "Tryon built the Price List app as an Ad Supported app. This SERVICE is provided by Tryon at no cost and is intended for use as is."),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service."),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy."),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Price List unless otherwise defined in this Privacy Policy."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Information Collection and Use"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way."),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "The app does use third-party services that may collect information used to identify you."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Log Data"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Cookies"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory."),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Service Providers"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "I may employ third-party companies and individuals due to the following reasons:"),
                SizedBox(
                  height: 2.h,
                ),
                textformate(text: "To facilitate our Service;"),
                SizedBox(
                  height: 1.h,
                ),
                pointtext(text: "To provide the Service on our behalf;"),
                SizedBox(
                  height: 1.h,
                ),
                pointtext(text: "To perform Service-related services; or"),
                SizedBox(
                  height: 1.h,
                ),
                pointtext(
                    text: "To assist us in analyzing how our Service is used."),
                SizedBox(
                  height: 2.h,
                ),
                textformate(
                    text:
                        "I want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Security"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Links to Other Sites"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Children’s Privacy"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions."),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Changes to This Privacy Policy"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page."),
                SizedBox(
                  height: 1.h,
                ),
                textformate(text: "This policy is effective as of 2022-08-25"),
                SizedBox(
                  height: 3.h,
                ),
                textheading(text: "Contact Us"),
                SizedBox(
                  height: 1.h,
                ),
                textformate(
                    text:
                        "If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at mindyourownbusiness9010@gmail.com.")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pointtext({String? text}) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.circle,
          size: 10,
        ),
        SizedBox(
          width: 2.h,
        ),
        textformate(text: text)
      ],
    );
  }

  Widget textheading({String? text}) {
    return Text(
      text ?? "",
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget textformate({String? text}) {
    return Text(text ?? "",
        style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify);
  }
}
