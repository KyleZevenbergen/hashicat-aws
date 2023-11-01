#!/bin/bash
# Script to deploy a very simple web application.
# The web app has a customizable image and some text.
cat << EOM > /var/www/html/index.html
<html>
  <head><title>Meow!</title></head>
  <body>
  <div style="width:800px;margin: 0 auto">

  <!-- BEGIN -->
  <center><img src="http://placekitten.com/600/400"></img></center>
  <center><h2>Meow World!</h2></center>
  <!-- END -->

  </div>
  </body>
</html>
EOM

echo "Script complete."
