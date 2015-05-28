require 'sinatra'

get '/index' do
	@name = ''
	erb :index
end

post '/login' do
	username = params[:username]
	password = params[:password]
end

get '/form' do
  erb :form
end

post '/form' do
  
  @email = params[:email]
  @password = params[:password]

  "Email is '#{@email}'"

end
