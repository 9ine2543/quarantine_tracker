double getRegisterFormSizing(value) {
  switch (value) {
    case '1':
      return 800;
    case '2':
      return 1070;
    default:
      return 600;
  }
}

bool enablePatientForm(value) {
  switch (value) {
    case '1':
      return true;
    case '2':
      return false;
    default:
      return false;
  }
}

bool enableRelativesForm(value) {
  switch (value) {
    case '1':
      return false;
    case '2':
      return true;
    default:
      return false;
  }
}
