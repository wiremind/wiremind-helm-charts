# References

 - https://github.com/aiven/pghoard
 - https://github.com/wiremind/docker-pghoard
 - https://hub.docker.com/r/wiremind/pghoard/

# Deploy

In order to use pghoard Helm Chart, you need run several steps:

## Users

Manually create a user for replication on your main database:

   CREATE USER pghoard PASSWORD 'putyourpasswordhere' REPLICATION;

Where the password is the apssword defined in your custom values.yaml

## Database

Manually create, if not already done, a database with the same name as the main user. It can be empty.

## Create custom secret

Currently, you will need to create a custom secret. See Skypallet helm chart for how to do this.
