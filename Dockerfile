FROM nginx:alpine

# Update package repositories and install gettext
RUN apk update && \
    apk add gettext

# Copy your application files to the appropriate directory
COPY . /usr/share/nginx/html

# Expose the desired port
EXPOSE 80

