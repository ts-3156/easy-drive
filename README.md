EasyDrive
----

I just want to copy files on google drive! (^^)

Installation
----

Add EasyDrive to your `Gemfile`.

```
gem 'easy_drive'
```

Initial Setup
----

1. You need to enable the Drive API for your app and download `client_secrets.json` to your project root directory.

    You can do this in your app's API project in the [Google APIs Console](https://code.google.com/apis/console/).

    See further information on [google-api-ruby-client-samples](https://github.com/google/google-api-ruby-client-samples/tree/master/drive)

2. Call `setup`, and both `easy_drive-oauth2.json` and `easy_drive-v2.cache` are created in project root directory.

    ```
    client = EasyDrive::Client.new
    client.setup # generate above 2 files.
    ```

Usage
----

```
client = EasyDrive::Client.new
client.copy(source_file_id, dest_folder_id, {title: 'new file name'})
```

That's all. Feel free to copy! (^^)

Advanced Usage
----

EasyDrive implements other Google Drive APIs.

Gets a file's metadata by ID.

```
client.get(file_id)
```

Insert(Upload) a new file.

```
client.insert('/etc/hello.txt', folder_id, {title: 'This is a new file.'})
```

Lists the user's all files.

```
client.list
```

Search files.

```
client.list({title: 'TITLE TEXT for searching'})
```

Search files in a specific folder.

```
client.list({title: 'TITLE TEXT for searching', folder_id: 'FOLDER_ID'})
```

EasyDrive is a wrapper of [google-api-ruby-client](https://github.com/google/google-api-ruby-client).  
So, you can call methods of google-api-ruby-client directly.

```
easy_drive_client = EasyDrive::Client.new
result = easy_drive_client.client.execute(
  :api_method => easy_drive_client.drive.files.get,
  :parameters => {
    'fileId' => 'file_id',
    'alt' => 'json'
  }
)
```

