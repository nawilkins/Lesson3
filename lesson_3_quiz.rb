# WEB DEV
# 1.)
#  - HTML stands for 'Hypertext Markup Language' and is a static markup langauge used to display the content of web pages
#  - CSS stands for 'Cascading Style Sheets' and is used to control the display of HTML elements on web pages
#   - Javascript is a dynamic langauge that has many applications. Regarding the web, it is primarily a browser-side language that allows for the manipulation of HTML/CSS elements and interactivity.

# 2.)
# 	HTTP Headers
# 	HTTP body (request type, path, etc)
	

# 3.) 
# 	Response code
# 	Body of request

# 4.)
# 	- To submit a post request, you use a form that has method set to 'POST' and the action set to the url that will process the request. You must also make sure the name of the input element carrying the payload matches the variable you want to process on the server e.g. input name="username" value="bob"
# 	- If you wanted a GET request, you change the method to method="get" and the variables/parameters will then be appended to the url

# 5.) 
# 	It is important for web developers to understand the stateless protocol of HTTP requests so that if we need to persist data across our applications, we know how to do it via databases, sessions, cookies

# 6.)
# 	Browsers provide a good GUI to interact with, but anything can make an HTTP request, such as mobile applications, desktop apps, video game consoles and/or command line interfaces.

# 7.)
# 	MVC stands for 'Model-View-Controller' and is a design paradigm for applications that that separates business logic/data from the display of the information. It uses 'controllers' that, based on the user interaction, extract data from the model and display it via views

# SINATRA

# 1.)
# 	Requests are processed via routes that respond to either GET or POST requests. Sinatra has a routing engine that takes the incoming request and return the logic we define for it.

# 2.)
# 	- Rendering displays the data after processing it.
# 	- Redirecting pushs the route to a different location and either does more processing or renders something else 

# 3.) 
# 	You show dynamic content by placing your Ruby code in <%= [code] %> tags

# 4.)
# 	The ERB template is turned into HTML after the Ruby code has been run for the given request and is sent back in the HTTP response body

# 5.) 
# 	The role of instance variables in Sinatra is to define paramters that change from request to request, but allow the program to either show or hide different states in the HTML that vary depending on conditions.