module EasyDrive
  module Files
    # @param file_id [String]
    #   ID of the origin file to copy
    # @param folder_id [String]
    #   ID of the destination folder which contains this file
    # @param options [Hash] A customizable set of options.
    # @option options [String] :title The title of this file
    # @return [Google::APIClient::Schema::Drive::V2::File]
    #   The copied file if successful, nil otherwise
    #   @see https://developers.google.com/drive/v2/reference/files
    def copy(file_id, folder_id, options = {})
      client = self.client
      drive = self.drive

      file = drive.files.copy.request_schema.new({
        'title' => options[:title],
        'parents' => [{:id => folder_id}]
      })
    
      result = client.execute(
        :api_method => drive.files.copy,
        :body_object => file,
        :parameters => {
          'fileId' => file_id,
          'alt' => 'json'})
    
      if result.status == 200
        result.data
      else
        puts "An error occurred: #{result.data['error']['message']}"
      end
    end
  end
end

