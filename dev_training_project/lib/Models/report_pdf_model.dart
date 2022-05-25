class Report {
  late String projectName;
  late String projectStartDate;
  late String projectEndDate;
  late String startDate;
  late String endDate;
  late String budgetType;
  late int sprintLength;
  late String budget;
  late String periodBudget;
  late String periodCost;
  late String periodResult;

  Report(
      this.projectName,
      this.projectStartDate,
      this.projectEndDate,
      this.startDate,
      this.endDate,
      this.budgetType,
      this.sprintLength,
      this.budget,
      this.periodBudget,
      this.periodCost,
      this.periodResult);
}

class Member {
  late String name;
  late String monthlyCost;
  late String totalCost;
  Member(
    this.name,
    this.monthlyCost,
    this.totalCost,
  );
}

class Invoice {
  Report? report;
  List<Member>? members;

  Invoice({this.report, this.members});
}
