#!/usr/bin/env bash

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

echo "${SSH_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${SSH_USER}

if ! id "${SSH_USER}" &> /dev/null; then
	adduser --disabled-password --gecos "" ${SSH_USER}
fi

service ssh start

sleep infinity & PID=$!
trap "kill $PID" INT TERM
wait

service ssh stop
