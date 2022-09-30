
# STEP 0. READ Configuration and Set it to ENV Variable
if [ -f .env ]
then
  echo "READING .env configuration"
  export $(cat .env | xargs)
fi

# STEP 1. COPY bundle files to your Output Directory
if [ ! -d $OUTPUT_DIRECTORY ]
then
  echo "DIRECTORY making >> $OUTPUT_DIRECTORY"
  mkdir -p $OUTPUT_DIRECTORY
fi
cp ./bundle/.env $OUTPUT_DIRECTORY/.env
cp ./bundle/DockerfileDev $OUTPUT_DIRECTORY/DockerfileDev
cp ./bundle/docker-compose-dev.yml $OUTPUT_DIRECTORY/docker-compose.yml

# STEP 2. RUN the Container to execute create-react-app
docker-compose -f docker-compose.yml up -d cra

# STEP 3. COPY CRA Project files inside the Container to your Output Directory
docker cp createReactAppExecutor:/app/.gitignore $OUTPUT_DIRECTORY/.gitignore
docker cp createReactAppExecutor:/app/README.md $OUTPUT_DIRECTORY/README.md
docker cp createReactAppExecutor:/app/package-lock.json $OUTPUT_DIRECTORY/package-lock.json
docker cp createReactAppExecutor:/app/package.json $OUTPUT_DIRECTORY/package.json
docker cp createReactAppExecutor:/app/public $OUTPUT_DIRECTORY/public
docker cp createReactAppExecutor:/app/src $OUTPUT_DIRECTORY/src
