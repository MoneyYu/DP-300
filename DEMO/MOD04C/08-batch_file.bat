echo "Press any key to start the production workload"
pause
start sqlcmd -S . -U ProductionUser -P Password -i "07-sql_script_to_keep_cpu_busy.sql"

echo "Press any key to start the reporting workload"
pause
start sqlcmd -S . -U ReportingUser -P Password -i "07-sql_script_to_keep_cpu_busy.sql"

echo "Press any key to start the dev workload"
pause
start sqlcmd -S . -U DevelopmentUser -P Password -i "07-sql_script_to_keep_cpu_busy.sql"

pause