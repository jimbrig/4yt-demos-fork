
# required in windows to mount smb share
sudo apt install cifs-utils

# mount smb using cli
sudo mount -t cifs -o username=alice //server_addr/AliceShare $PWD/mounted/

# Use uid=x and gid=x to map the user/group on the client to the appropriate IDs on the server.
# like if your local user and group id is 1000 (for most cases) do:
sudo mount -t cifs -o username=alice,uid=1000,gid=1000 //server_addr/AliceShare $PWD/mounted/

# unmount using cli
sudo umount $PWD/mounted/
