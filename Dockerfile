FROM nginx:alpine

# Set Alpine mirror URL
ENV ALPINE_MIRROR http://dl-cdn.alpinelinux.org

# Update package repositories and install gettext
RUN apk update --repository=${ALPINE_MIRROR}/alpine/v3.17/main && \
    apk add --repository=${ALPINE_MIRROR}/alpine/v3.17/main gettext

# Copy your application files to the appropriate directory
COPY . /usr/share/nginx/html

# Expose the desired port
EXPOSE 80