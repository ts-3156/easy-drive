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

    # Lists files.
    # @param options [Hash] A customizable set of options.
    #   @option options [String] :title The title for searching
    #   @option options [String] :folder_id The parent folder ID for searching
    #
    # @return [Array<Google::APIClient::Schema::Drive::V2::File>]
    #   List of File resources.
    #   @see https://developers.google.com/drive/v2/reference/files
    def list(options = {})
      client = self.client
      drive = self.drive

      params = {
        "maxResults" => 1000
      }

      if options.has_key?(:title)
        params['q'] = "title = '#{options[:title]}'"
      end

      api_method =
        if options.has_key?(:folder_id)
          params['folderId'] = options[:folder_id]
          drive.children.list
        else
          drive.files.list
        end

      result = []
      page_token = nil
      begin
        if page_token.to_s != ''
          params['pageToken'] = page_token
        end
        api_result = client.execute(
          :api_method => api_method,
          :parameters => params)

        if api_result.status == 200
          files = api_result.data
          result.concat(files.items)
          page_token = files.next_page_token
        else
          puts "An error occurred: #{result.data['error']['message']}"
          page_token = nil
        end
      end while page_token.to_s != ''

      if result.size > 0 && 
        result.first.class.name == 'Google::APIClient::Schema::Drive::V2::ChildReference'

        _result = []
        batch = Google::APIClient::BatchRequest.new
        result.each do |r|
          batch.add(
            :api_method => drive.files.get,
            :parameters => {
              'fileId' => r.id,
              'alt' => 'json'}
          ){|api_result| _result.push(api_result.data) }
        end        
        client.execute(batch)
        result = _result
      end

      result
    end
  end
end

