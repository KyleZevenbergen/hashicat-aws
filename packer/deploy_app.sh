#!/bin/bash
# Script to deploy a very simple web application.
# The web app has a customizable image and some text.
cat << EOM > /var/www/html/index.html
<html>
  <head><title>Woof!</title></head>
  <body>
  <div>

  <!-- BEGIN -->
  <center><img src="https://placedog.net/1000/s/?r"></img></center>
  <!-- END -->

  </div>
  </body>
</html>
EOM

echo "Script complete."
