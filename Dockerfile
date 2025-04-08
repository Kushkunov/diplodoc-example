FROM node:latest AS node

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app
COPY . .
RUN npm i @diplodoc/cli -g

RUN yfm -i ./docs -o ./_docs-build  --add-map-file --allow-custom-resources

FROM nginx:alpine AS nginx

# Copy  Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the build output to replace the default nginx contents.
COPY --from=node /app/_docs-build /usr/share/nginx/html

# Expose port 80
EXPOSE 5000

# Start nginx
CMD ["nginx", "-g", "daemon off;"]