# Considerations when running Jellyfin in K8s

Do not attempt to run this application in HA.  
It is not designed for that due to the use of SQLite.  

Running the app in HA will break the database.  

With this setup the application's cache, metadata and images
must be on the same machine.  
Leaving those in the NFS share on the remote machine will cause slowness.
