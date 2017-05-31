#https://docs.docker.com/engine/reference/commandline/build/
if [ -z $CURRENT ]; then
	CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
fi

if [ -z $1 ]; then
  1=6.6.1
fi

docker build --no-cache=true -t iam6a64/splunk:$1 $CURRENT
docker build -t splunk/splunk:latest $CURRENT
