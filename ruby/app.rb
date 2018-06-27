require "sinatra"
require "sinatra/json"
require "securerandom"
require "excon"


API_URL = ENV['API_URL'] || raise("You should set API_URL")

web_api = Excon.new(API_URL)

get "/healthcheck" do
    json :status => "OK" 
end

get "/am-i-famous" do
    name = params[:person]
    response = web_api.post(
        :path => "/job",
        :headers => {
            'Content-Type': 'application/json'
        },
        :body => { 
            search: name,
            job_id: "#{SecureRandom.uuid}" 
        }.to_json
    )
    content_type 'application/json'
    response.body
end

get "/result/:id" do |id|
    response = web_api.get(
        :path => "/result/#{id}",
    )
    content_type 'application/json'
    status response.status
    response.body
end

delete "/result/:id" do |id|
    response = web_api.delete(
        :path => "/result/#{id}",
    )
    status response.status
    response.body
end

not_found do 
    status 404
end
