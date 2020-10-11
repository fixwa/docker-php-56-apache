docker build -t "fixwa/php5.6-apache" .
docker run -d -p 80:80 -v //c/MyWebsiteFolder/www:/vhost/current/ fixwa/php5.6-apache