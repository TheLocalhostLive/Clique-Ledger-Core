# Use the official Node.js image as the base image
FROM node:20

# Set the working directory in the container
WORKDIR /server

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the application dependencies
RUN npm install --force


# Copy the application code to the working directory
COPY . .

#.env is the for the host machince and .env.doc is for docker container, so after copying the server
#folder we are deleting the .env and renaming the .env.docker to .env
RUN rm .env
RUN mv .env.docker .env
# Copy the entrypoint script
# COPY entrypoint.sh /usr/local/bin/

# # Make the entrypoint script executable
# RUN chmod +x /usr/local/bin/entrypoint.sh

# ENTRYPOINT ["entrypoint.sh"]


# # Expose port 3000 for the application
# EXPOSE 3000

# Specify the command to run the application
#CMD ["sh", "-c", "npx prisma migrate reset --force && npx prisma migrate dev --name init && npm run dev"]
CMD ["npm", "run", "dev"]