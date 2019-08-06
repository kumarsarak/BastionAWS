#!/usr/bin/env bash

set -e

keys=$(aws secretsmanager get-secret-value --secret-id tripit-service-keypair | jq -r ".SecretString")
public_key=$(echo "$keys" | jq -r ".PublicKey")
private_key=$(echo "$keys" | jq -r ".PrivateKey")

echo "Creating users..."
users_file='/etc/users.txt'
while IFS= read -r user
do
    adduser -D "$user" 2>/dev/null || true
    passwd -u "$user" 2>/dev/null
    ssh_dir="/home/$user/.ssh"
    mkdir -p "${ssh_dir}"

    if [[ "$user" == "tripit" ]]; then
        echo "$public_key" > "${ssh_dir}/authorized_keys"
        echo "$private_key" > "${ssh_dir}/tripit-service-keypair.pem"
    fi

    chown -R "$user:$user" "${ssh_dir}"
done < "$users_file"
echo "done"

# add aws rds hosts
echo "Creating RDS host entries..."
cp /etc/hosts /etc/hosts.bak

RDS_CLUSTERS=$(aws rds describe-db-clusters)
RDS_READER_HOSTS=$(echo "${RDS_CLUSTERS}" | jq -r ".DBClusters[] | [.ReaderEndpoint,.DBClusterIdentifier] | @tsv" | sed -e 's/[[:space:]]tripit-/ /' -e '/^tripit-[0-9]*-.*$/d' -e 's/$/\-rds/')
RDS_WRITER_HOSTS=$(echo "${RDS_CLUSTERS}" | jq -r ".DBClusters[] | [.Endpoint,.DBClusterIdentifier] | @tsv" | sed -e 's/[[:space:]]tripit-/ /' -e '/^tripit-[0-9]*-.*$/d' -e 's/$/\-rds-writer/')
RDS_HOSTS=$(printf "%s\n%s\n" "${RDS_READER_HOSTS}" "${RDS_WRITER_HOSTS}" | sort)
echo "${RDS_HOSTS}" | while read HOST ALIAS; do getent hosts "${HOST}" | awk '{ print $1 }' | tr "\n" " "; echo "${ALIAS}"; done >> /etc/hosts
echo "done"

# Set motd and start cron to ensure it updates appropriately
/etc/periodic/15min/motd
crond -bS

supervisord -c /etc/supervisor/conf.d/supervisord.conf
