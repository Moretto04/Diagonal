
SET COMPOSE_COMMAND=docker compose
%COMPOSE_COMMAND% version >nul 2>&1
IF %ERRORLEVEL% EQU 9009 (
    SET COMPOSE_COMMAND=docker-compose
    %COMPOSE_COMMAND% version >nul 2>&1
    IF %ERRORLEVEL% EQU 9009 (
        ECHO "Neither Docker Compose (plugin) or Docker-Compose (standalone) were found."
        ECHO "You need to have Docker and Docker Compose (any version) installed in order to run this script!"
        ECHO "Check https://docs.docker.com/desktop/install/windows-install/ or https://docs.rancherdesktop.io/getting-started/installation#windows to get started."
        EXIT /B 1
    )
)
SET compose_file_custom="%~dp0\docker-compose.local.yml"
set compose_file_dist="%~dp0\.docker\docker-compose.yml"
set env_file=--env-file "%~dp0\.docker\.env"

IF EXIST %compose_file_custom% (
    SET compose_file=-f %compose_file_dist% -f %compose_file_custom%
) ELSE (
    SET compose_file=-f %compose_file_dist%
)

%COMPOSE_COMMAND% %compose_file% %env_file% up %*