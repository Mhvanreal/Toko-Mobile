// ignore: file_names
library my_project.globals;

Map<String, dynamic>? loggedInUser;


void logout() {
  loggedInUser = null;
}