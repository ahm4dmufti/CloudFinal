# small official Node base image
FROM node:20-alpine
# work inside /app in the container
WORKDIR /app
# copy your code in (no npm install needed)
COPY app/ ./
# the app listens on port 8080
EXPOSE 8080
# run as non-root user for security
USER node
# command that starts the server
CMD ["node", "server.js"]
