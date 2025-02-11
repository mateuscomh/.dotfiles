#!/bin/bash
ponto_montagem="/mnt/Dados"
if mountpoint -q "$ponto_montagem"; then
    rsync -Cravztp /var/lib/vnstat $ponto_montagem/@Pessoal/Backups/Vnstat | tee /tmp/bkpvnstat
    date +"%H:%M:%S - %d/%m/%Y" >> /tmp/bkpvnstat
else
    echo "A pasta não está acessível."
    echo "Assunto: Ponto de montagem $ponto_montagem nao montado" | /usr/bin/mail -s "Ponto de montagem não está pronto" ${USER}
    exit 1
fi

