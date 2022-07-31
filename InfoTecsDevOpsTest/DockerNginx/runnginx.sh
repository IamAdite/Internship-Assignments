echo "-------------------------------Build the image-------------------------------"

sleep 1

docker build -t nginx-infotecs:1.0 .

sleep 1

echo "Creating nginx.conf"

sleep 1

cat <<EOT >> nginx.conf
worker_processes  1;

events {
    worker_connections  1024;

}

http {

    default_type  application/octet-stream;
    
    sendfile        on;
    
    keepalive_timeout  65;
    
    server {
        root        /rootfs/var/www/html;
    
        listen       80;
            
        server_name  localhost;
    
        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

    }
}
EOT

sleep 1

echo "nginx.conf created!"

sleep 1

echo "-------------------------------Run Container-------------------------------" 

sleep 1

docker run -d -p 80:80 -v "$PWD/nginx.conf":/etc/nginx/nginx.conf nginx-infotecs:1.0

echo "nginx container is running on localhost!"
