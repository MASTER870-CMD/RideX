class EmissionRecord {
  final DateTime testDate;
  final DateTime dueDate;
  final String vehicleNumber;
  final String? certificatePath;

  const EmissionRecord({
    required this.testDate,
    required this.dueDate,
    required this.vehicleNumber,
    this.certificatePath,
  });
}
