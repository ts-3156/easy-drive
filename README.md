EasyDrive
----

I just want to copy files on google drive! (^^)

Usage
----

First, you need to enable the Drive API for your app and download `client_secrets.json` to your project root directory.

You can do this in your app's API project in the [Google APIs Console](https://code.google.com/apis/console/).

See further information on [google-api-ruby-client-samples](https://github.com/google/google-api-ruby-client-samples/tree/master/drive)

----

Second, call `setup`, and both `easy_drive-oauth2.json` and `easy_drive-v2.cache` are created in project root directory.

```
client = EasyDrive::Client.new
client.setup # generate above 2 files.
```

----

Last, feel free to copy! (^^)

```
client = EasyDrive::Client.new
client.copy(source_file_id, dest_folder_id, {title: 'new file name'})
```
