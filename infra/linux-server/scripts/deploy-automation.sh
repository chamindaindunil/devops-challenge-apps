#!/bin/bash

echo "Cloning repository..."
git clone https://github.com/chamindaindunil/devops-challenge-apps.git app-repo || (cd app-repo && git pull)

# Web App
echo "Building Web App..."
cd app-repo/web
npm install
npm run build

echo "Restarting Web App..."
# Assuming the Web App runs on port 3000
# Ensure the app is not already running and then start it
lsof -i :3000 | awk '{print $2}' | tail -n +2 | xargs kill -9
nohup npm start &

cd ..

# API App
echo "Building API..."
cd app-repo/api
npm install
npm run build

echo "Restarting API..."
# Assuming the API runs on port 3001
# Ensure the app is not already running and then start it
lsof -i :3001 | awk '{print $2}' | tail -n +2 | xargs kill -9
nohup npm start &

echo "Applications deployed and restarted successfully!"
