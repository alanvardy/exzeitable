# cypress-run.sh

MIX_ENV=systemtest mix ecto.reset
echo "===STARTING PHX SERVER==="
MIX_ENV=systemtest mix phx.server &
pid=$! # Store server pid
npx cypress run
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
