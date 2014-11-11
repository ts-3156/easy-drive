module EasyDrive
  module Files
    def copy(client, drive, file_id, folder_id, options = {})
      client = self.client
      drive = self.drive

      file = drive.files.insert.request_schema.new({
        'title' => options[:title],
        'parents' => [{:id => folder_id}]
      })
    
      result = client.execute(
        :api_method => drive.files.copy,
        :body_object => file,
        :parameters => {
          'fileId' => file_id,
          'alt' => 'json'})
    
      result.data
    end
  end
end

