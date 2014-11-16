module EasyDrive
  module Files
    # Gets a file's metadata by ID
    # @param file_id [String]
    #   ID of the file to get
    # @return [Google::APIClient::Schema::Drive::V2::File]
    #   The got file if successful, nil otherwise
    #   @see https://developers.google.com/drive/v2/reference/files
    def get(file_id)
      client = self.client
      drive = self.drive

      result = client.execute(
        :api_method => drive.files.get,
        :parameters => {
          'fileId' => file_id,
          'alt' => 'json'})

      if result.status == 200
        result.data
      else
        puts "An error occurred: #{result.data['error']['message']}"
      end
    end

    # Insert(Upload) a new file
    # @param file_name [String]
    #   Name of file to upload
    # @param folder_id [String]
    #   ID of the destination folder which contains this file
    # @param options [Hash] A customizable set of options.
    #   @option options [String] :title The title of this file
    #   @option options [String] :description The description of this file
    #   @option options [String] :mine_type The mine type of this file
    # @return [Google::APIClient::Schema::Drive::V2::File]
    #   The uploaded file if successful, nil otherwise
    #   @see https://developers.google.com/drive/v2/reference/files
    def insert(file_name, folder_id, options = {})
      client = self.client
      drive = self.drive

      file = drive.files.insert.request_schema.new({
        'title' => options[:title],
        'description' => options[:description],
        'mimeType' => options[:mime_type],
        'parents' => [{:id => folder_id}]
      })

      media = Google::APIClient::UploadIO.new(file_name, options[:mime_type])
      result = client.execute(
        :api_method => drive.files.insert,
        :body_object => file,
        :media => media,
        :parameters => {
          'uploadType' => 'multipart',
          'alt' => 'json'})

      if result.status == 200
        return result.data
      else
        puts "An error occurred: #{result.data['error']['message']}"
      end
    end
    alias_method :upload, :insert

    # Creates a copy of the specified file
    # @param file_id [String]
    #   ID of the origin file to copy
    # @param folder_id [String]
    #   ID of the destination folder which contains this file
    # @param options [Hash] A customizable set of options.
    #   @option options [String] :title The title of this file
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

