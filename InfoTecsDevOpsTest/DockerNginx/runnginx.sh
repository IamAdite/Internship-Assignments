echo "-------------------------------Build the image-------------------------------"

sleep 1

docker build -t nginx-infotecs:1.0 .

sleep 1

echo "-------------------------------Run Container-------------------------------" 

sleep 1

docker run -d -p 80:80 -v "$PWD/nginx.conf":/etc/nginx/nginx.conf nginx-infotecs:1.0

echo "nginx container is running on localhost!"
