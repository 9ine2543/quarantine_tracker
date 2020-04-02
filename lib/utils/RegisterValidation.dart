bool validateGeneralInputs(
    firstname, surname, citizenId, phoneNumber, organization) {
  if (firstname != '' &&
      surname != '' &&
      citizenId != '' &&
      phoneNumber != '' &&
      organization != '') {
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

bool validateRelativeInputs(days, patientIDCard, patientName, patientSurname) {
  if (days != '' &&
      patientIDCard != '' &&
      patientName != '' &&
      patientSurname != '') {
    return true;
  } else {
    return false;
  }
}
