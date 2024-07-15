#!/bin/sh

if [ "$1" = "--provision" ]; then
  # Run the provision command
  shift # Remove the flag from the argument list
  npx prisma migrate reset --force && npx prisma migrate dev --name init && npm run dev
  
else
  # Run the default command
  npm run dev
fi