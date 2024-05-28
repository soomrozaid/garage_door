// Future<bool> getDoors() async {
//   // var headers = {
//   //   'Authorization':
//   //       'Bearer eyJraWQiOiJrZUhCa2h2OEVJVzhIZ2hSUExveUI0T09VcU4xd3hQZ1BGK2wrelZsRkxBPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiI5NWEyNTVjNi0yNWI4LTQ5YzYtODI3Mi1iODdjN2NiMzRhMmUiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0yLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMl85dUh6Z2F4bnYiLCJjbGllbnRfaWQiOiIyN2lpYzhjM2J2c2xxbmdsM2hzbzgzdDc0YiIsIm9yaWdpbl9qdGkiOiIxYzNkODI5Ni04MTU1LTQ2YzctOGUzZi03NWE5YmQ3NzI3ZTQiLCJldmVudF9pZCI6ImYzYmZhZDhkLWEwMTYtNDNmNS1iYjZmLTc3MWI3ZWIxZTM0YSIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3MTQyNjU2NTksImV4cCI6MTcxNjc5NTQzNiwiaWF0IjoxNzE2NzkxODM2LCJqdGkiOiI5NDhmM2MwMC02ZWI1LTQ2MjAtYTcxZC05NmFmOGM3ZWIzMjgiLCJ1c2VybmFtZSI6InNvb21yb3phaWRAZ21haWwuY29tIn0.jTyj0hRwAvEj3TXCWIaadSO55PEZqT1C4gH3W-twH-IvH66E2Hf8aEbf5Ocja29ve3THfAIfUtAU3n99IAMxCChyNDItyu8cY2e9XJIl9UvcT708qJQT09Pmee3YVcK6FTvNLbyswttBG86ikRMK-lfHybQzF3ZD1ZeiyTS9E61v8uZssW5w9a7RPegl2Wby9gqjNP6QFepB-fMipwq35n9sQXBRmwSNWlBreENzxKcg5CVoQKGyxEpRbDmC2hhomWfOt6bWHqGPo4e9TN6QlHgZPC9_Gz8c47fwmOLXvbEFJDUdnOX0DfM885_TTA1U4IsSAHvw2_XRXsvN9Njf2A'
//   // };
//   var headers = createHeader(await retrieveAuthToken() ?? token);
//   var request =
//       http.Request('GET', Uri.parse('https://api.smartgarage.systems/devices'));

//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     // String str = await response.stream.bytesToString();

//     print(await response.stream.bytesToString());
//   } else {
//     if (response.reasonPhrase == "Unauthorized") {
//       print("yessit");

//       // var request = http.Request(
//       //     'POST', Uri.parse('https://api.smartgarage.systems/session'));
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
// }
