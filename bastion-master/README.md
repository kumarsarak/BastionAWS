# TripIt's Bastion Host
This is the bastion host used to connect to any of our services running in AWS. Keys are stored in AWS Secrets Manager and rotated daily.

### Getting started
1. Ensure you have the latest cli with `tripit update`
2. Grab temporary AWS credentials to the account of choice with `tripit awscred`
3. Connect to the bastion host `ssh tripit-bastion`

NOTE: the host changes when you switch aws accounts but the command remains the same. It will always be `ssh tripit-bastion`.
If you need to manually change the host, the ssh config file is at `~/.tripit/ssh_config` 

### How it works
Part of the `tripit awscred` command adds your temporary AWS credentials to an environment variable that gets passed to the bastion host.
The bastion host then uses these credentials to authenticate you and logs you in.

### I can't login, Help!
1. Check that you have access to the AWS environment. A simple `aws s3 ls` should let you know.
2. Check that your user name is in `bastion/host/users.txt`
3. Reach out to someone on the Transformers team for help.