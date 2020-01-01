EXIT_STATUS=0

echo "Building Workspace"
yarn install || EXIT_STATUS=$?


echo "Adding TypeScript compiler globally"
yarn global add typescript


cd packages/data
echo "Installing @libstack/data"
yarn || EXIT_STATUS=$?
echo "Building @libstack/data"
yarn build || EXIT_STATUS=$?


cd ../keycloak
echo "Installing @libstack/keycloak"
yarn || EXIT_STATUS=$?
echo "Building @libstack/keycloak"
yarn build || EXIT_STATUS=$?


cd ../router
echo "Installing @libstack/router"
yarn || EXIT_STATUS=$?
echo "Building @libstack/router"
yarn build || EXIT_STATUS=$?


cd ../sequel
echo "Installing @libstack/sequel"
yarn || EXIT_STATUS=$?
echo "Building @libstack/sequel"
yarn build || EXIT_STATUS=$?


cd ../server
echo "Installing @libstack/server"
yarn || EXIT_STATUS=$?
echo "Building @libstack/server"
yarn build || EXIT_STATUS=$?


cd ../tester
echo "Installing @libstack/tester"
yarn || EXIT_STATUS=$?
echo "Building @libstack/tester"
yarn build || EXIT_STATUS=$?

exit $EXIT_STATUS