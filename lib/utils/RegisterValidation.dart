bool validateGeneralInputs(
    firstname, surname, String citizenId, String phoneNumber, String organization) {
  if (firstname != '' &&
      surname != '' &&
      citizenId.length == 13 &&
      phoneNumber.length == 10 &&
      organization.length == 4) {
    return true;
  } else {
    return false;
  }
}

bool validatePatientInputs(days, hospital) {
  if (days != '' && hospital != '') {
    return true;
  } else {
    return false;
  }
}

bool validateRelativeInputs(days, String patientIDCard, patientName, patientSurname) {
  if (days != '' &&
      patientIDCard.length == 13 &&
      patientName != '' &&
      patientSurname != '') {
    return true;
  } else {
    return false;
  }
}
