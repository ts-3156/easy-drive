module EasyDrive
  module Files
    # @param file_id [String] source file_id
    # @param folder_id [String] destination folder_id
    # @param options [Hash] A customizable set of options.
    # @option options [String] :title new file name
    def copy(file_id, folder_id, options = {})
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

