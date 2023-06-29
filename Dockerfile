# Use a base image
FROM nginx:latest

# Copy the index.html file to the default Nginx HTML directory
COPY ./project/index.html /usr/share/nginx/html/

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
