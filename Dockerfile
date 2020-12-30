# Tag this as 'builder'-Phase. Everything beneath the FROM command will be referred to as builder phase.
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .
RUN npm install

# Copy files - Volumes no longer needed
COPY . .

# The build-Files will be found in the container in '/app/build'
RUN npm run build

# Configuration for the RUN-phase. No tag necessary: A new FROM statement always starts a new phase
FROM nginx

# Copy the result of the builder-phase into the nginx container
# The '--from=build' directive states that we're copying stuff out of the builder-phase
# The '/app/build' arguments name the location of the files from the builder-phase we want to copy.
# The '/usr/share/nginx/html' is the location where the nginx-server expects the content to serve. 
COPY --from=builder /app/build /usr/share/nginx/html

# No RUN-Command necessary because the default startup command of the nginx-server is already the startup command