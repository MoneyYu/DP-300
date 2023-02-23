--  Creating logins
CREATE LOGIN ProductionUser
WITH PASSWORD = 'Password',
     CHECK_POLICY = OFF;
CREATE USER [ProductionUser] FOR LOGIN [ProductionUser];

CREATE LOGIN ReportingUser WITH PASSWORD = 'Password', CHECK_POLICY = OFF;
CREATE USER [ReportingUser] FOR LOGIN [ReportingUser];

CREATE LOGIN DevelopmentUser
WITH PASSWORD = 'Password',
     CHECK_POLICY = OFF;
CREATE USER [DevelopmentUser] FOR LOGIN [DevelopmentUser];
