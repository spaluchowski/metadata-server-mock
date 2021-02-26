require 'sinatra'


class MetadataServerMock < Sinatra::Base

  known_properties =["name", "description", "ticker", "logo", "url", "unit"]

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
      JSON.parse(File.read(file)).to_json
    else
      "Requested subject '#{params[:metadata]}' not found"
    end
  end

  get "/metadata/:metadata/properties/:property" do
    content_type :json

    file = "metadata/#{params[:metadata]}"
    if File.exists? file
      m = JSON.parse(File.read(file))
      m[params[:property]] ? m[params[:property]].to_json : "Requested property '#{params[:property]}' not found"
    else
      "Requested subject '#{params[:metadata]}' not found"
    end
  end

  post "/metadata/query" do
    content_type :json

    files = Dir["metadata/*"].map{ |f| f.split("/").last}
    ps = JSON.parse(request.body.read)
    requested_metadata = (files & ps["subjects"])
    resp = []
    requested_metadata.each do |f|
      m = JSON.parse(File.read("metadata/#{f}"))

      if ps["properties"]
        unneeded_properties = (known_properties - ps["properties"])
        unneeded_properties.each {|u| m.delete(u)}
      end
      resp << m
    end

    {"subjects" => resp}.to_json
  end

end
