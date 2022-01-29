--Crating the resource pools
CREATE RESOURCE POOL ProductionPool WITH(
min_cpu_percent=50, 
		max_cpu_percent=100, 
		min_memory_percent=50, 
		max_memory_percent=100, 
		AFFINITY SCHEDULER = AUTO
);
CREATE RESOURCE POOL SecondaryPool WITH(
min_cpu_percent=0, 
		max_cpu_percent=30, 
		min_memory_percent=0, 
		max_memory_percent=30, 
		AFFINITY SCHEDULER = AUTO
);