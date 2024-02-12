#!/usr/bin/bash

while true
do
    git pull
    ./executar-testes-final.sh
    git add .
    git commit -m "execução de testes $(date)"
    git push -u origin main
    sleep 60
done