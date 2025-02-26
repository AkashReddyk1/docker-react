FROM node:alpine as builder

WORKDIR /usr/frontend/

COPY package.json ./

RUN npm install

COPY . ./

# Set the NODE_OPTIONS environment variable to use legacy OpenSSL providers
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build


# /usr/frontend/build <--- this is the folder that we want to copy to the nginx container
FROM nginx as runner
COPY --from=builder /usr/frontend/build /usr/share/nginx/html  
# /usr/share/nginx/html is the default folder that nginx uses to serve static files
# We are copying the build folder from the builder phase to the nginx container
# This is the only thing that we need to do to get the frontend to work with nginx
# We don't need to specify a CMD because the nginx image already has a default CMD that starts the server