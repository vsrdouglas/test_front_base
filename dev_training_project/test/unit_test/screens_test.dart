import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Models/addmember_model.dart';
import 'package:my_app/Models/report_request_model.dart';
import 'package:my_app/Screens/available_empl_equipment.dart';
import 'package:my_app/Screens/history_equipment/history_equipment_screen.dart';
import 'package:my_app/Screens/report_screen.dart';

void main() {
  late dynamic info;
  group('history equipments screen', () {
    info = {
      "equipment": {
        "id": "01G22Q6NPFTC6NV9KE4NBAN6RS",
        "model": "ndsl",
        "serial": "fdsnln",
        "purchaseDate": null,
        "warranty": null,
        "status": "Working",
        "note": null,
        "billingNumber": null,
        "cost": null,
        "createdAt": "2022-05-02T15:46:10.309Z",
        "updatedAt": "2022-05-02T15:46:10.309Z",
        "deletedAt": null,
        "processorId": "01FYVND7AZQJSHDY5HPWREQW1R",
        "memoryId": "01FYVRH30M37C4D3PRCNS7235N",
        "storageId": "01FYVRH30M37C4D3PRCNS7TGEE",
        "companyId": "01FWP0WKSX6B18Z4GFP4QQ30RH",
        "company": {
          "id": "01FWP0WKSX6B18Z4GFP4QQ30RH",
          "company": "Tunts",
          "createdAt": "2022-05-02T14:25:52.497Z",
          "updatedAt": "2022-05-02T14:25:52.497Z",
          "deletedAt": null
        },
        "processor": {
          "id": "01FYVND7AZQJSHDY5HPWREQW1R",
          "model": "Intel I9 teste",
          "createdAt": "2022-05-02T14:25:52.488Z",
          "updatedAt": "2022-05-02T14:25:52.488Z",
          "deletedAt": null
        },
        "memory": {
          "id": "01FYVRH30M37C4D3PRCNS7235N",
          "size": "16",
          "unit": "GB",
          "createdAt": "2022-05-02T14:25:52.491Z",
          "updatedAt": "2022-05-02T14:25:52.491Z",
          "deletedAt": null
        },
        "storage": {
          "id": "01FYVRH30M37C4D3PRCNS7TGEE",
          "type": "HD",
          "size": "1",
          "unit": "TB",
          "createdAt": "2022-05-02T14:25:52.494Z",
          "updatedAt": "2022-05-02T14:25:52.494Z",
          "deletedAt": null
        }
      },
      "userHasEquipments": [
        {
          "id": "01G22Q6X9VNXHEYDPBCZG28TAC",
          "startDate": "2022-05-02",
          "endDate": null,
          "createdAt": "2022-05-02T15:46:18.055Z",
          "updatedAt": "2022-05-02T15:46:18.055Z",
          "deletedAt": null,
          "equipmentId": "01G22Q6NPFTC6NV9KE4NBAN6RS",
          "userId": "01FXTBES6Q3BS6ZZBTHTM02CK1",
          "user": {
            "id": "01FXTBES6Q3BS6ZZBTHTM02CK1",
            "name": "Admin Test",
            "imageTumb":
                "https://firebasestorage.googleapis.com/v0/b/project-manager-dead4.appspot.com/o/Untitled%20design%20(1).png?alt=media&token=ff31564d-2666-4e52-9415-94c499a20581"
          }
        }
      ]
    };
    test('history equipments convert list', () async {
      final result = convertList(info);
      expect(result.equipmentInfo.id, '01G22Q6NPFTC6NV9KE4NBAN6RS');
    });

    test('history equipments getListUsers', () async {
      final result = getListUsers(info);
      expect(result?.length, greaterThan(0));
    });

    test('history equipments listConverterDateTime', () async {
      String now1 = '2022-09-01';
      String now2 = '2021-09-01';
      String now3 = '2023-04-08';
      List<String> listDate = [now1, now2, now3];
      final result = listConverterDateTime(listDate);
      expect(result.length, greaterThan(0));
      expect(result[0], DateFormat("yyyy-MM-dd").parse(listDate[0]));
    });
  });

  group('available_empl_equipment', () {
    test('available_empl_equipment list converter', () async {
      final info = {
        'id': 'GGDGDGD',
        'name': 'Teste',
        'imageTumb': 'nsdifosidn94ifiifif'
      };
      List<dynamic> list = [info, info, info];
      final result = listconverter(list);
      expect(result.length, greaterThan(0));
      expect(result[0].runtimeType, MemberModel);
    });
  });

  group('available_members_list_screen', () {
    test('available_members_list_screen list converter', () async {
      final info = {
        'id': 'GGDGDGD',
        'name': 'Teste',
        'allocation': 0.4,
        'imageTumb': 'nsdifosidn94ifiifif'
      };
      List<dynamic> list = [info, info, info];
      final result = listconverter(list);
      expect(result.length, greaterThan(0));
      expect(result[0].runtimeType, MemberModel);
    });
  });

  group('list_projects_add', () {
    test('list_projects_add list converter', () async {
      final info = {
        'id': 'GGDGDGD',
        'name': 'Teste',
        'allocation': 0.4,
        'imageTumb': 'nsdifosidn94ifiifif'
      };
      List<dynamic> list = [info, info, info];
      final result = listconverter(list);
      expect(result.length, greaterThan(0));
      expect(result[0].runtimeType, MemberModel);
    });
  });

  group('report_screen', () {
    test('report_screen _modelReport', () async {
      final info = [
        {
          "sprintNumber": 1,
          "sprintStartDate": "2022-03-07",
          "sprintEndDate": "2022-03-21",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": []
        },
        {
          "sprintNumber": 2,
          "sprintStartDate": "2022-03-21",
          "sprintEndDate": "2022-04-04",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": []
        },
        {
          "sprintNumber": 3,
          "sprintStartDate": "2022-04-04",
          "sprintEndDate": "2022-04-18",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": []
        },
        {
          "sprintNumber": 4,
          "sprintStartDate": "2022-04-18",
          "sprintEndDate": "2022-05-02",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": []
        }
      ];
      final result = ReportScreenState().modelReport(info, 1, 2);
      expect(result.length, greaterThan(0));
      expect(result[0].runtimeType, ReportRequest);
    });

    test('report_screen _usersReport', () async {
      final info = [
        {
          "sprintNumber": 1,
          "sprintStartDate": "2022-03-07",
          "sprintEndDate": "2022-03-21",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": [
            {
              "id": "01FXTBES6Q3BS6ZZBTHTM02CK1",
              "name": "Admin Test",
              "monthlyWage": "102.00",
              "imageTumb":
                  "https://firebasestorage.googleapis.com/v0/b/project-manager-dead4.appspot.com/o/Untitled%20design%20(1).png?alt=media&token=ff31564d-2666-4e52-9415-94c499a20581",
              "costAtSprint": "44.77"
            }
          ]
        },
        {
          "sprintNumber": 2,
          "sprintStartDate": "2022-03-21",
          "sprintEndDate": "2022-04-04",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": []
        },
        {
          "sprintNumber": 3,
          "sprintStartDate": "2022-04-04",
          "sprintEndDate": "2022-04-18",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": []
        },
        {
          "sprintNumber": 4,
          "sprintStartDate": "2022-04-18",
          "sprintEndDate": "2022-05-02",
          "sprintCost": "0.00",
          "sprintResult": "10.00",
          "isForecast": false,
          "users": []
        }
      ];
      final result = ReportScreenState().usersReport(info, 1, 2);
      expect(result['01FXTBES6Q3BS6ZZBTHTM02CK1'], isNotNull);
    });
  });
}
