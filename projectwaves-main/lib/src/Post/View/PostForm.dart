import 'dart:io';

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_waves/colors.dart';
import 'package:project_waves/csc_picker/csc_picker.dart';
import 'package:project_waves/firebase_options.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:project_waves/src/Models/Post.dart';
import 'package:project_waves/src/Auth/Components/my_textfield.dart';
import 'package:project_waves/home.dart';

import '../../Auth/Components/button.dart';
import '../../Auth/Utils/database.dart';
import '../Components/TextFieldForm.dart';
import '../Controller/PostController.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key, this.post});
  final Post? post;

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();

  String? countryValue;
  String? stateValue;
  String? cityValue;

  var _imagePath;
  var _currentLocale;
  final PostController postController = PostController();

  @override
  void initState() {
    _getCurrentLocale();
    super.initState();
  }

  Future<void> getImageFromDevice({String type = "Gallery"}) async {
    String? imagePath = await postController.getImageFromDevice(type: type);
    setState(() {
      _imagePath = imagePath;
    });
  }

  Future<void> _getCurrentLocale() async {
    try {
      final currentLocale = await Devicelocale.currentLocale;
      print((currentLocale != null)
          ? currentLocale
          : "Unable to get currentLocale");
      setState(() => {
        _currentLocale = currentLocale?.substring(3,5),
      });
    } on PlatformException {
      print("Error obtaining current locale");
    }
  }

  Widget? getImage(){
    if(_imagePath != null){
      return ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.file(
              File(_imagePath),
              width: 200,
              height: 200,
              fit: BoxFit.cover
          )
      );
    }
    else if(widget.post != null){
      return ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child:Image.network(
              widget.post!.image,
              width: 200,
              height: 200,
              fit: BoxFit.cover
          )
      );
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    title.text = widget.post?.title ?? "";
    description.text = widget.post?.description ?? "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('New post'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                MyTextFieldForm(
                  controller: title,
                  hinText: 'Title',
                  obscureText: false,
                  keyboard: TextInputType.text,
                  maxLines: 1,
                ),
                SizedBox(height: 30),
                CSCPicker(
                  currentState: widget.post?.state,
                  currentCountry: widget.post?.country,

                  showStates: true,
                  showCities: false,

                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border:
                      Border.all(color: Colors.grey.shade300, width: 1)),

                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                      Border.all(color: Colors.grey.shade300, width: 1)),

                  countrySearchPlaceholder: "Pays",
                  stateSearchPlaceholder: "Region",
                  citySearchPlaceholder: "Ville",

                  countryDropdownLabel: "Pays",
                  stateDropdownLabel: "Region",
                  cityDropdownLabel: "Ville",

                  ///selected item style [OPTIONAL PARAMETER]
                  selectedItemStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  dropdownHeadingStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),

                  dropdownItemStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  dropdownDialogRadius: 10.0,

                  searchBarRadius: 10.0,

                  onCountryChanged: (value) {
                    setState(() {
                      print(value);
                      countryValue = value;
                    });
                  },

                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },

                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                SizedBox( height: 30),
                MyTextFieldForm(
                    controller: description,
                    hinText: 'Description',
                    obscureText: false,
                    keyboard: TextInputType.text,
                    maxLines: 4),

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.purple,
                  ),
                  onPressed: () => getImageFromDevice(),
                  child: getImage() ??
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () async {
                    await postController.sharePost(
                      title.text,
                      description.text,
                      countryValue!,
                      stateValue!,
                      _imagePath,
                      widget.post?.thumbnail,
                      DatabaseAuthMethods().getCurrentUserId(),
                      postId: widget.post?.postId,
                    );
                  },
                  text: "Share",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
