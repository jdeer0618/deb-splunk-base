#https://docs.docker.com/engine/reference/commandline/build/
if [ -z $CURRENT ]; then
  CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
fi

if [ -z $1 ]; then
  docker_image_tag='6.6.1'
else
  docker_image_tag=$1
fi

docker build --no-cache=true -t iam6a64/splunk:$docker_image_tag $CURRENT
docker build -t iam6a64/splunk:latest $CURRENT
