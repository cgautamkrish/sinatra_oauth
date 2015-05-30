require 'sinatra'
require 'yaml/store'
require 'securerandom'
require 'json'

get '/' do
  erb :form
end

post '/form' do
  @email = params[:email]
  @password = params[:password]

  # check if user has permission and create authorization grant
  @store = YAML::Store.new 'resources/users.yml'
  @users = @store.transaction { @store['users'] }
  @key = @users.key?(@email)
  puts @key
  if @key == true
  	@pass = @users[@email]
  	if @pass == @password
  		puts "User '#{@email}' authenticated. Generating authorization grant.."
  		@random_string = SecureRandom.hex
  		@grants = YAML::Store.new 'resources/grants.yml'
  		@grants.transaction do
			@grants['grants'] ||= {}
			@grants['grants'][@email] = @random_string
		end
		# route to view with grant value
  		erb :result
  	else
  		# send value and route to view
  		@result = "Authentication failed. Email/Password incorrect."
  		erb :fail
  	end
  else
  	# send value and route to view 
  	@result = "Authentication failed. Email/Password incorrect."
  	erb :fail
  end
end

post '/access_token' do
  # If using raw JSON to send request
  # @data = JSON.parse(request.body.read.to_s)
  # puts @data
  # @client_email = @data['client_email']
  # @authorization_grant = @data['authorization_grant']
  @client_email = params[:client_email]
  @authorization_grant = params[:authorization_grant]

  @users = YAML::Store.new 'resources/users.yml'
  @users = @users.transaction { @users['users'] }

  @check_if_user_exists = @users.key?(@client_email)
  if @check_if_user_exists == true
	@grants = YAML::Store.new 'resources/grants.yml'
  	@grants = @grants.transaction { @grants['grants'] }
  	@check_if_grant_created = @grants.key?(@client_email) 	
  	if @check_if_user_exists == true
  		@grant = @grants[@client_email]
  		if @grant == @authorization_grant
  			puts "User '#{@client_email}' and grant authenticated. Generating access token.."
  			@access_token = SecureRandom.hex
  			@tokens = YAML::Store.new 'resources/tokens.yml'
			@tokens.transaction do
				@tokens['tokens'] ||= {}
				@tokens['tokens'][@client_email] = @access_token
			end
			# return in the headers
			response.headers['access_token'] = @access_token
			response.headers['client_email'] = @client_email
			response.headers['authorization_grant'] = @authorization_grant
		else
			# return 500 
			error 500, {error: "Incorrect credentials"}.to_json
		end
	else
		# return 500
		error 500, {error: "Incorrect credentials"}.to_json
	end
  else
  	# return 500
  	error 500, {error: "Incorrect credentials"}.to_json
  end
end

# Test if access_token is correct
get '/resource' do
	@access_token = request.env['HTTP_ACCESS_TOKEN']

	@tokens = YAML::Store.new 'resources/tokens.yml'
  	@tokens = @tokens.transaction { @tokens['tokens'] }
  	@access = false

  	@tokens.each do |key, value|
  		puts value
  		if value == @access_token
  			@access = true
  		end
  	end

  	if @access == false
  		error 500, {error: "Incorrect credentials"}.to_json
  	end

  	# authenticated and able to retrieve resource
	content_type :json
  	{ :resource_1 => 'Have access! Yay!', :resource_2 => 'Any data you want from server!' }.to_json

end



