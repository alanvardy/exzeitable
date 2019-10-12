# cypress-ci.sh

MIX_ENV=systemtest mix ecto.reset
echo "===STARTING PHX SERVER==="
echo "===IF STARTING CYPRESS FAILS==="
echo "===RUN npm install cypress --save-dev ==="
echo "===IN THE assets/ FOLDER==="
MIX_ENV=systemtest mix phx.server &
pid=$! # Store server pid
# ./assets/node_modules/.bin/cypress run  --record --key 114a5558-7d13-4b81-a67e-3deb9e3f073d
./assets/node_modules/.bin/cypress run
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
