import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/country.dart';
import 'package:test_game/game/data/models/gender.dart';
import 'package:test_game/game/data/models/user_model.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';
import 'package:test_game/game/ui/widgets/forms/select_input_component.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> genders = {};
  Map<String, dynamic> countries = {};

  @override
  void initState() {
    context.read<ServerBloc>().add(ServerDestroyPayload());
    context.read<ServerBloc>().add(PullGenderEvent());
    context.read<ServerBloc>().add(PullCountryEvent());
    getContactList();
    super.initState();
  }

  getContactList() async {
    if (await FlutterContacts.requestPermission()) {
      context.read<ServerBloc>().add(FetchContactEvent());
    }
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: display(),
    );
  }

  bool isOn = false;
  UserModel userModel = UserModel.empty();

  Widget display() {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServerBloc, ServerState>(
          listener: (context, state) {
            setState(() {
              isOn = state.token == "" ? false : true;
              userModel = state.user;
            });
          },
        ),
        BlocListener<ServerBloc, ServerState>(
          listener: (context, state) {
            setState(
              () {
                if (state.countries.isNotEmpty) {
                  countries = {};
                  countries.addAll({"": "Select country"});
                  for (CountryModel country in state.countries) {
                    countries.addAll({country.id: country.name});
                  }
                }
                if (state.genders.isNotEmpty) {
                  genders = {};
                  genders.addAll({"": "Select gender"});
                  for (GenderModel gender in state.genders) {
                    genders.addAll({gender.id: gender.name});
                  }
                }
              },
            );
          },
        ),
      ],
      child: isOn ? profile() : register(),
    );
  }

  String codeNumber = "";
  String phoneNumber = "";

  Widget profile() {
    context.read<ServerBloc>().add(
          ServerPutPayload(
            value: userModel.id,
            key: "user_id",
          ),
        );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.4),
                child: Image.asset(Assets.background, height: MediaQuery.of(context).size.width * 0.4, width: MediaQuery.of(context).size.width * 0.4, fit: BoxFit.cover,),
              ),
              displayTap(key: "Name", value: userModel.name),
              displayTap(key: "Email", value: userModel.email),
              displayTap(key: "Phone", value: userModel.phone, readOnly: true),
              if (genders.isNotEmpty)
                displayTapSelect(
                    key: "Gender", value: userModel.genderId, values: genders),
              if (countries.isNotEmpty)
                displayTapSelect(
                    key: "Country",
                    value: userModel.countryId,
                    values: countries),

              const SizedBox( height: 15,),
              serverListeners(
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonComponent(
                        buttonSize: 40,
                        mainAxisAlignment: MainAxisAlignment.center,
                        isLoading: loading,
                        title: "Update",
                        onPressed: () {
                          context.read<ServerBloc>().add(UpdateUserEvent());
                        },
                        transparent: false,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
    );
  }

  bool startChange = false;

  Widget displayTap(
      {required String key,
      required String value,
      bool label = true,
      bool readOnly = false}) {
    if (value != "") {
      if (key.toLowerCase() == "phone") {
        if (phoneNumber != "") {
          value = phoneNumber;
        }
        if (value.isNotEmpty) {
          if (value[0] == "0") {
            value = value.replaceFirst("0", "");
          }
        }
        if (value.startsWith(codeNumber)) {
          value = value.replaceFirst(codeNumber, "");
        }
        if (!context
            .read<ServerBloc>()
            .state
            .payload
            .containsKey(key.toLowerCase())) {
          context.read<ServerBloc>().add(
                ServerPutPayload(
                  value:
                      value.startsWith(codeNumber) ? value : codeNumber + value,
                  key: key.toLowerCase(),
                ),
              );
        }
      } else {
        if (!context
            .read<ServerBloc>()
            .state
            .payload
            .containsKey(key.toLowerCase())) {
          context.read<ServerBloc>().add(
                ServerPutPayload(
                  value: value,
                  key: key.toLowerCase(),
                ),
              );
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          if (label)
            Expanded(
              child: Text(
                key + " :",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            flex: 4,
            child: InputComponent(
              onSave: () {},
              onChange: (change) {
                if (key.toLowerCase() == "phone") {
                  if (change.isNotEmpty) {
                    if (change[0] == "0") {
                      change = change.replaceFirst("0", "");
                    }
                  }
                  if (!value.startsWith(codeNumber)) {
                    change = codeNumber + change;
                  }
                }
                startChange = true;
                context.read<ServerBloc>().add(ServerPutPayload(value: change, key: key.toLowerCase()));
              },
              initialValue: value.contains("threematch.co.tz") ? "" : value,
              readOnly: readOnly,
            ),
          ),
        ],
      ),
    );
  }

  Widget displayTapSelect({
    required String key,
    required String value,
    required Map<String, dynamic> values,
    bool label = true,
    int col = 4,
  }) {
    if (value != "") {
      if (!context
          .read<ServerBloc>()
          .state
          .payload
          .containsKey(key.toLowerCase())) {
        context.read<ServerBloc>().add(
              ServerPutPayload(
                value: value,
                key: key.toLowerCase(),
              ),
            );
      }
    }

    if (key.toLowerCase() == "code") {
      String ph = "";
      values.forEach((b, v) {
        if (value.startsWith(b)) {
          ph = b;
          setState(() {
            if (phoneNumber.startsWith(codeNumber)) {
              phoneNumber = phoneNumber.replaceFirst(codeNumber, "");
            }
            codeNumber = ph;
          });
        }
      });
      value = ph;
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            flex: label ? 1 : col,
            child: Text(
              key + " :",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SelectInputComponent(
              onSave: () {},
              onChange: (change) {
                startChange = true;
                setState(() {
                  codeNumber = change;
                });
                context.read<ServerBloc>().add(
                      ServerPutPayload(
                        value: change,
                        key: key.toLowerCase(),
                      ),
                    );
              },
              items: values,
              hintText: "Select " + key,
              initialValue: value,
            ),
          )
        ],
      ),
    );
  }

  Widget register() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(Assets.orange),
                const Text(
                  "Give Away",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (userModel == UserModel.empty())
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: displayTapSelect(
                    key: "Code",
                    value: userModel.phone,
                    values: phones,
                    label: false,
                    col: 2,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: displayTap(
                      key: "Phone", value: userModel.phone, label: false),
                ),
              ],
            ),
          if (userModel != UserModel.empty())
            InputComponent(
              hintText: "CODE",
              initialValue: "",
              onSave: (String? value) {},
              onChange: (value) {
                context.read<ServerBloc>().add(
                      ServerPutPayload(
                        value: value,
                        key: "token",
                      ),
                    );
                context.read<ServerBloc>().add(
                      ServerPutPayload(
                        value: "",
                        key: "verify",
                      ),
                    );
                context.read<ServerBloc>().add(
                      ServerPutPayload(
                        value: userModel.phone,
                        key: "name",
                      ),
                    );
              },
              validate: "string",
            ),
          const SizedBox(
            height: 4.0,
          ),
          serverListeners(
            child: Row(
              children: [
                Expanded(
                  child: ButtonComponent(
                    isLoading: loading,
                    title: userModel != UserModel.empty()
                        ? "Verify Token"
                        : "Login",
                    onPressed: () {
                      if (context
                              .read<ServerBloc>()
                              .state
                              .payload
                              .containsKey("code") &&
                          context
                              .read<ServerBloc>()
                              .state
                              .payload
                              .containsKey("phone")) {
                        context.read<ServerBloc>().add(
                              ServerPutPayload(
                                value: context
                                        .read<ServerBloc>()
                                        .state
                                        .payload["code"] +
                                    context
                                        .read<ServerBloc>()
                                        .state
                                        .payload["phone"],
                                key: "name",
                              ),
                            );
                      }
                      context.read<ServerBloc>().add(
                            RegisterUserEvent(),
                          );
                    },
                    transparent: false,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget serverListeners({Widget? child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) =>
              previous.logging != current.logging,
          listener: (context, state) {
            setState(
              () {
                loading = state.logging;
              },
            );
          },
        ),
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) => previous.phones != current.phones,
          listener: (context, state) {
            if (state.phones.isNotEmpty) {
              context.read<ServerBloc>().add(
                    RequestFriendEvent(),
                  );
            }
          },
        ),
      ],
      child: child ?? Container(),
    );
  }

  Map<String, String> phones = {
    "": "Select Code",
    "255": "TZ (+255)",
    "213": "Algeria (+213)",
    "376": "Andorra (+376)",
    "244": "Angola (+244)",
    "1264": "Antigua Barbuda (+1268)",
    "54": "Argentina (+54)",
    "374": "Armenia (+374)",
    "297": "Aruba (+297)",
    "61": "Australia (+61)",
    "43": "Austria (+43)",
    "994": "Azerbaijan (+994)",
    "1242": "Bahamas (+1242)",
    "973": "Bahrain (+973)",
    "880": "Bangladesh (+880)",
    "1246": "Barbados (+1246)",
    "375": "Belarus (+375)",
    "32": "Belgium (+32)",
    "501": "Belize (+501)",
    "229": "Benin (+229)",
    "1441": "Bermuda (+1441)",
    "975": "Bhutan (+975)",
    "591": "Bolivia (+591)",
    "387": "Bosnia Herzegovina (+387)",
    "267": "Botswana (+267)",
    "55": "Brazil (+55)",
    "673": "Brunei (+673)",
    "359": "Bulgaria (+359)",
    "226": "Burkina Faso (+226)",
    "257": "Burundi (+257)",
    "855": "Cambodia (+855)",
    "237": "Cameroon (+237)",
    "1": "Canada (+1)",
    "238": "Cape Verde Islands (+238)",
    "1345": "Cayman Islands (+1345)",
    "236": "Central African Republic (+236)",
    "56": "Chile (+56)",
    "86": "China (+86)",
    "57": "Colombia (+57)",
    "269": "Comoros (+269)",
    "242": "Congo (+242)",
    "682": "Cook Islands (+682)",
    "506": "Costa Rica (+506)",
    "385": "Croatia (+385)",
    "53": "Cuba (+53)",
    "90392": "Cyprus North (+90392)",
    "357": "Cyprus South (+357)",
    "42": "Czech Republic (+42)",
    "45": "Denmark (+45)",
    "253": "Djibouti (+253)",
    "1809": "Dominica (+1809)",
    "1809": "Dominican Republic (+1809)",
    "593": "Ecuador (+593)",
    "20": "Egypt (+20)",
    "503": "El Salvador (+503)",
    "240": "Equatorial Guinea (+240)",
    "291": "Eritrea (+291)",
    "372": "Estonia (+372)",
    "251": "Ethiopia (+251)",
    "500": "Falkland Islands (+500)",
    "298": "Faroe Islands (+298)",
    "679": "Fiji (+679)",
    "358": "Finland (+358)",
    "33": "France (+33)",
    "594": "French Guiana (+594)",
    "689": "French Polynesia (+689)",
    "241": "Gabon (+241)",
    "220": "Gambia (+220)",
    "7880": "Georgia (+7880)",
    "49": "Germany (+49)",
    "233": "Ghana (+233)",
    "350": "Gibraltar (+350)",
    "30": "Greece (+30)",
    "299": "Greenland (+299)",
    "1473": "Grenada (+1473)",
    "590": "Guadeloupe (+590)",
    "671": "Guam (+671)",
    "502": "Guatemala (+502)",
    "224": "Guinea (+224)",
    "245": "Guinea - Bissau (+245)",
    "592": "Guyana (+592)",
    "509": "Haiti (+509)",
    "504": "Honduras (+504)",
    "852": "Hong Kong (+852)",
    "36": "Hungary (+36)",
    "354": "Iceland (+354)",
    "91": "India (+91)",
    "62": "Indonesia (+62)",
    "98": "Iran (+98)",
    "964": "Iraq (+964)",
    "353": "Ireland (+353)",
    "972": "Israel (+972)",
    "39": "Italy (+39)",
    "1876": "Jamaica (+1876)",
    "81": "Japan (+81)",
    "962": "Jordan (+962)",
    "7": "Kazakhstan (+7)",
    "254": "Kenya (+254)",
    "686": "Kiribati (+686)",
    "850": "Korea North (+850)",
    "82": "Korea South (+82)",
    "965": "Kuwait (+965)",
    "996": "Kyrgyzstan (+996)",
    "856": "Laos (+856)",
    "371": "Latvia (+371)",
    "961": "Lebanon (+961)",
    "266": "Lesotho (+266)",
    "231": "Liberia (+231)",
    "218": "Libya (+218)",
    "417": "Liechtenstein (+417)",
    "370": "Lithuania (+370)",
    "352": "Luxembourg (+352)",
    "853": "Macao (+853)",
    "389": "Macedonia (+389)",
    "261": "Madagascar (+261)",
    "265": "Malawi (+265)",
    "60": "Malaysia (+60)",
    "960": "Maldives (+960)",
    "223": "Mali (+223)",
    "356": "Malta (+356)",
    "692": "Marshall Islands (+692)",
    "596": "Martinique (+596)",
    "222": "Mauritania (+222)",
    "269": "Mayotte (+269)",
    "52": "Mexico (+52)",
    "691": "Micronesia (+691)",
    "373": "Moldova (+373)",
    "377": "Monaco (+377)",
    "976": "Mongolia (+976)",
    "1664": "Montserrat (+1664)",
    "212": "Morocco (+212)",
    "258": "Mozambique (+258)",
    "95": "Myanmar (+95)",
    "264": "Namibia (+264)",
    "674": "Nauru (+674)",
    "977": "Nepal (+977)",
    "31": "Netherlands (+31)",
    "687": "New Caledonia (+687)",
    "64": "New Zealand (+64)",
    "505": "Nicaragua (+505)",
    "227": "Niger (+227)",
    "234": "Nigeria (+234)",
    "683": "Niue (+683)",
    "672": "Norfolk Islands (+672)",
    "670": "Northern Marianas (+670)",
    "47": "Norway (+47)",
    "968": "Oman (+968)",
    "680": "Palau (+680)",
    "507": "Panama (+507)",
    "675": "Papua New Guinea (+675)",
    "595": "Paraguay (+595)",
    "51": "Peru (+51)",
    "63": "Philippines (+63)",
    "48": "Poland (+48)",
    "351": "Portugal (+351)",
    "1787": "Puerto Rico (+1787)",
    "974": "Qatar (+974)",
    "262": "Reunion (+262)",
    "40": "Romania (+40)",
    "7": "Russia (+7)",
    "250": "Rwanda (+250)",
    "378": "San Marino (+378)",
    "239": "Sao Tome Principe (+239)",
    "966": "Saudi Arabia (+966)",
    "221": "Senegal (+221)",
    "381": "Serbia (+381)",
    "248": "Seychelles (+248)",
    "232": "Sierra Leone (+232)",
    "65": "Singapore (+65)",
    "421": "Slovak Republic (+421)",
    "386": "Slovenia (+386)",
    "677": "Solomon Islands (+677)",
    "252": "Somalia (+252)",
    "27": "South Africa (+27)",
    "34": "Spain (+34)",
    "94": "Sri Lanka (+94)",
    "290": "St. Helena (+290)",
    "1869": "St. Kitts (+1869)",
    "1758": "St. Lucia (+1758)",
    "249": "Sudan (+249)",
    "597": "Suriname (+597)",
    "268": "Swaziland (+268)",
    "46": "Sweden (+46)",
    "41": "Switzerland (+41)",
    "963": "Syria (+963)",
    "886": "Taiwan (+886)",
    "7": "Tajikstan (+7)",
    "66": "Thailand (+66)",
    "228": "Togo (+228)",
    "676": "Tonga (+676)",
    "1868": "Trinidad Tobago (+1868)",
    "216": "Tunisia (+216)",
    "90": "Turkey (+90)",
    "7": "Turkmenistan (+7)",
    "993": "Turkmenistan (+993)",
    "1649": "Turks Caicos Islands (+1649)",
    "688": "Tuvalu (+688)",
    "256": "Uganda (+256)",
    "44": "UK (+44)",
    "380": "Ukraine (+380)",
    "971": "United Arab Emirates (+971)",
    "598": "Uruguay (+598)",
    "1": "USA (+1)",
    "7": "Uzbekistan (+7)",
    "678": "Vanuatu (+678)",
    "379": "Vatican City (+379)",
    "58": "Venezuela (+58)",
    "84": "Vietnam (+84)",
    "1284": "Virgin Islands - British (+1284)",
    "1340": "Virgin Islands - US (+1340)",
    "681": "Wallis Futuna (+681)",
    "969": "Yemen (North)(+969)",
    "967": "Yemen (South)(+967)",
    "260": "Zambia (+260)",
    "263": "Zimbabwe (+263)",
  };
}
