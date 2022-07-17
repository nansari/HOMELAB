*How to connect*
```
sudo -u postgres -i
  OR
psql -h localhost -U postgres
CREATE ROLE demo superuser;
CREATE USER demo;
GRANT ROOT TO username;
ALTER ROLE username WITH LOGIN;

