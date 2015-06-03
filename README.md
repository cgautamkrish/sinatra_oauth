# sinatra_oauth
OAuth 2.0 implementation in Sinatra</br>
Instead of connecting to a DB (too lazy to go setup tables/columns/connectors :P), I'll be using YAML for storing data. Of course, in a true blue OAuth implementation, storing in a DB is vital.

<h3>Pre-requisites</h3>
Sinatra framework - http://www.sinatrarb.com/
SecureRandom gem - http://ruby-doc.org/stdlib-1.9.2/libdoc/securerandom/rdoc/SecureRandom.html
ERB for layouts/templating

Only SecureRandom gem has to be installed separately. 

<h3>Usage Instructions</h3>
1. Install the needed dependencies </br>
2. Checkout the flow of OAuth 2.0 <a href="http://www.mutuallyhuman.com/assets/posts/2013/04/09/oauth2-flow-2004f40d50cfc7b4d77a5b8112963b8f.png">here</a>. </br>
3. Start up the server and navigate to 'localhost:4567/' if you're running it on localhost.</br>
4. You'll see a form; to be able to login, add your email and a password to the users.yml file in resources folder.</br>
5. Login and follow the instructions!</br>

<h3>Requesting for access token</h3>

			    <p>1. The authorization grant will be valid till you request for another authorization grant. If you've successfully received a new grant, the old grant will become invalid.</p>
			    <p>2. To request an access_token, make a <b>POST</b> HTTP request to the token endpoint, 'localhost:4567/access_token' by adding the following parameters using the "application/x-www-form-urlencoded" format with a character encoding of UTF-8 in the HTTP request entity-body:</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;- <b>grant_type</b> REQUIRED. Value MUST be set to 'credentials'</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;- <b>client_email</b> REQUIRED. Example value: 'client@root.com'</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;- <b>authorization_grant</b> REQUIRED. Example value: 'a70bc158dd5151c3dd92dc2e13c1b3ba'</p>
				<p>3. If successful, you will be returned with a <b>200 OK</b> HTTP response with an additonal parameter that contains the access_token. A sample request and response is shown below.</p>
				<pre><p><b>HTTP Request</b><br>
					POST /token HTTP/1.1<br>
					Host: localhost:4567/access_token<br>
					client_email: client@root.com<br>
					Content-Type: application/x-www-form-urlencoded<br>
					authorization_grant:a70bc158dd5151c3dd92dc2e13c1b3ba<br>
				</p></pre>
				<pre><p><b>HTTP Response</b><br>
					POST /token HTTP/1.1<br>
					Host: localhost:4567/access_token<br>
					client_email: client@root.com<br>
					Content-Type: application/x-www-form-urlencoded<br>
					authorization_grant:a70bc158dd5151c3dd92dc2e13c1b3ba<br>
					access_token:dg2gd28t2649d29486rtd9234rtd32
				</p></pre>

<h3>Successful Response</h3>
If everything goes well, you can get your protected resource by calling '/resource' with HTTP POST request with access token data.

