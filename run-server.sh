#!/bin/bash

init() {
    COMPOSE_EXECUTABLE="docker composer"
    if ! $COMPOSE_EXECUTABLE version &>/dev/null; then
        COMPOSE_EXECUTABLE="docker-compose"
        if ! $COMPOSE_EXECUTABLE --version &>/dev/null; then
            echo "Neither Docker Compose (plugin) or Docker-Compose (standalone) were found."
            echo "You need to have Docker and Docker Compose (any version) installed in order to run this script!"
            echo "Check https://docs.docker.com/engine/install/ and https://docs.docker.com/compose/install/ to get started."
            exit 1
        fi
    fi
    self=$(which "$0")
    project_path=$(dirname "$(realpath "$self")")
    compose_file_custom="./docker-compose.local.yml"
    compose_file_dist="${project_path}/.docker/docker-compose.yml"
    env_file="--env-file=${project_path}/.docker/.env"

    if [ -f "${compose_file_custom}" ]; then
        compose_file=(-f "$compose_file_dist" -f "$compose_file_custom")
    else
        compose_file=(-f "$compose_file_dist")
    fi
}

init

${COMPOSE_EXECUTABLE} "${compose_file[@]}" "$env_file" up "$@"