// ignore_for_file: constant_identifier_names

enum Flavor {
  DEV,
  PROD,
}

class F {
  static Flavor? appFlavor;

  static List get url {
    switch (appFlavor) {
      // case Flavor.DEV:
      //   return 'App flavors Dev';
      case Flavor.PROD:
        return [
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/projects/',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/users/',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/projects/',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/login',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/users/me',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/reset/key',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/reset/token',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/reset',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/all',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/projects/user',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/equipments',
          'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/equipments/users/available',
        ];
      default:
        return [
          'https://project-manager-reborn.herokuapp.com/api/v1/projects/',
          'https://project-manager-reborn.herokuapp.com/api/v1/users/',
          'https://project-manager-reborn.herokuapp.com/api/v1/projects/',
          'https://project-manager-reborn.herokuapp.com/api/v1/auth/login',
          'https://project-manager-reborn.herokuapp.com/api/v1/users/me',
          'https://project-manager-reborn.herokuapp.com/api/v1/auth/reset/key', //email,
          'https://project-manager-reborn.herokuapp.com/api/v1/auth/reset/token', //email, recovery key
          'https://project-manager-reborn.herokuapp.com/api/v1/auth/reset', //email, nova senha, reset: true
          'https://project-manager-reborn.herokuapp.com/api/v1/users/all',
          'https://project-manager-reborn.herokuapp.com/api/v1/projects/user',
          'https://project-manager-reborn.herokuapp.com/api/v1/equipments',
          'https://project-manager-reborn.herokuapp.com/api/v1/equipments/users/available'
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/projects/',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/users/',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/projects/',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/login',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/users/me',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/reset/key',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/reset/token',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/auth/reset',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/users/all',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/projects/user',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/equipments',
          // 'https://dev-training-be-ewxas5vvoa-uc.a.run.app/api/v1/equipments/users/available',
        ];
    }
  }
}

class Logs {
  static Flavor? appFlavor;
  static bool get analytics {
    switch (appFlavor) {
      // case Flavor.DEV:
      //   return 'App flavors Dev';
      case Flavor.PROD:
        return true;
      default:
        return false;
    }
  }
}
