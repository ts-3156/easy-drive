easy-drive
----

I just want to copy files on google drive.

```
client = EasyDrive::Client.new
client.copy(source_file_id, dest_folder_id, {title: 'new file name'})
```
