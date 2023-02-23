--Creating the workload groups and assigning them to resource pools
CREATE WORKLOAD GROUP ProductionGroup USING ProductionPool;

CREATE WORKLOAD GROUP ReportingGroup USING SecondaryPool;

CREATE WORKLOAD GROUP DevelopmentGroup USING SecondaryPool;