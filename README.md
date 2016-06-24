# Resinci Server

*WARNING* This is a WIP prototype.

Resinci is a tool for generating docker daemons on-demand via HTTP.
Assuming the server is running, you can generate daemons with the following:

```
host=<some host>
port=8080
context=a-repo-name

curl --silent $host:$port/dockers/create?context=$context # returns env vars
```

