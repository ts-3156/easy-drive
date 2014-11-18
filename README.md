EasyDrive
----

I just want to copy files on google drive! (^^)

Installation
----

Add EasyDrive to your `Gemfile`.

```
gem 'easy_drive'
```

Usage
----

1. You need to enable the Drive API for your app and download `client_secrets.json` to your project root directory.

    You can do this in your app's API project in the [Google APIs Console](https://code.google.com/apis/console/).

    See further information on [google-api-ruby-client-samples](https://github.com/google/google-api-ruby-client-samples/tree/master/drive)

2. Call `setup`, and both `easy_drive-oauth2.json` and `easy_drive-v2.cache` are created in project root directory.

    ```
    client = EasyDrive::Client.new
    client.setup # generate above 2 files.
    ```

That's all. Feel free to copy! (^^)

```
client = EasyDrive::Client.new
client.copy(source_file_id, dest_folder_id, {title: 'new file name'})
```
