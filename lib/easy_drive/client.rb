require 'easy_drive/files'
require 'easy_drive/version'

require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'

module EasyDrive
  class Client
    include EasyDrive::Files

    API_VERSION = 'v2'
    CACHED_API_FILE = "easy_drive-#{API_VERSION}.cache"
    CREDENTIAL_STORE_FILE = "easy_drive-oauth2.json"

    attr_accessor :application_name
    attr_reader :client, :drive

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [EasyDrive::Client]
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    # @note refresh_token bug fix
    # @see https://github.com/google/google-api-ruby-client/issues/90
    def file_format_bug_fix(credential_store_file)
      return if !File.exists?(credential_store_file)
      temp = nil 
      File.open(credential_store_file, "r") do |f| 
        temp = JSON.load(f)
        if temp["authorization_uri"].class != String
          temp["authorization_uri"] =
            "https://accounts.google.com/o/oauth2/auth"
        end 
        if temp["token_credential_uri"].class != String
          temp["token_credential_uri"] =
            "https://accounts.google.com/o/oauth2/token"
        end 
      end 
      File.open(credential_store_file, "w") do |f| 
        f.write(temp.to_json)
      end 
    end
    
    def setup()
      client = Google::APIClient.new(:application_name => self.class.to_s,
          :application_version => version)
    
      file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
      if file_storage.authorization.nil?
        client_secrets = Google::APIClient::ClientSecrets.load
        flow = Google::APIClient::InstalledAppFlow.new(
          :client_id => client_secrets.client_id,
          :client_secret => client_secrets.client_secret,
          :scope => ['https://www.googleapis.com/auth/drive']
        )
        client.authorization = flow.authorize(file_storage)
      else
        client.authorization = file_storage.authorization
      end
    
      drive = nil
      if File.exists? CACHED_API_FILE
        File.open(CACHED_API_FILE) do |file|
          drive = Marshal.load(file)
        end
      else
        drive = client.discovered_api('drive', API_VERSION)
        File.open(CACHED_API_FILE, 'w') do |file|
          Marshal.dump(drive, file)
        end
      end
    
      @client = client
      @drive = drive

      return client, drive
    end

    # @return [String]
    def version
      "#{EasyDrive::Version}"
    end
  end
end
