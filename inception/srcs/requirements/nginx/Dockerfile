#Sets base image to Alpine Linux 3.16
FROM alpine:3.16

#Install Nginx without caching package files
RUN	apk update && apk upgrade && apk add --no-cache nginx

#Listen on port 443
EXPOSE 443

#Start Nginx in the foreground, so it keeps running as the main process in the container
CMD ["nginx", "-g", "daemon off;"]
