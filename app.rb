require 'sinatra'


class MetadataServerMock < Sinatra::Base

  get "/" do
    "MetadataServerMock ¯\_(ツ)_/¯"
  end

  get "/metadata/789ef8ae89617f34c07f7f6a12e4d65146f958c0bc15a97b4ff169f1" do
    content_type :json
    JSON.parse(File.read("metadata/789ef8ae89617f34c07f7f6a12e4d65146f958c0bc15a97b4ff169f1")).to_json
  end

  get "/metadata/789ef8ae89617f34c07f7f6a12e4d65146f958c0bc15a97b4ff169f16861707079636f696e" do
    content_type :json
    JSON.parse(File.read("metadata/789ef8ae89617f34c07f7f6a12e4d65146f958c0bc15a97b4ff169f16861707079636f696e")).to_json
  end

  post "/metadata/query" do
    content_type :json
    JSON.parse(File.read("metadata/query_response")).to_json
  end

end
