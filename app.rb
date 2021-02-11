require 'sinatra'


class MetadataServerMock < Sinatra::Base

  get "/" do
    metadatas = Dir["metadata/*"].map{ |f| "<li><a href='#{f}'>#{f}</a></li>"}.join('')
    %Q{
      <h3>Metadata Server Mock:</h3>
      <ul>
        #{metadatas}
      </ul>
    }
  end

  get "/metadata/:metadata" do
    content_type :json

    file = "metadata/#{params[:metadata]}"
    if File.exists? file
      JSON.parse(File.read("metadata/#{params[:metadata]}")).to_json
    else
      "Requested subject '#{params[:metadata]}' not found"
    end
  end

  post "/metadata/query" do
    content_type :json

    files = Dir["metadata/*"].map{ |f| f.split("/").last}
    ps = JSON.parse(request.body.read)
    mocked_files = (files & ps["subjects"])
    resp = []
    mocked_files.each do |f|
      resp << JSON.parse(File.read("metadata/#{f}"))
    end

    {"subjects" => resp}.to_json
  end

end
