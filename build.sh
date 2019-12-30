EXIT_STATUS=0

echo "Building Workspace"
yarn install || EXIT_STATUS=$?

echo "Building @libstack/data"
cd packages/data
yarn build || EXIT_STATUS=$?

echo "Building @libstack/keycloak"
cd ../keycloak
yarn build || EXIT_STATUS=$?

echo "Building @libstack/router"
cd ../router
yarn build || EXIT_STATUS=$?

echo "Building @libstack/sequel"
cd ../sequel
yarn build || EXIT_STATUS=$?

echo "Building @libstack/server"
cd ../server
yarn build || EXIT_STATUS=$?

echo "Building @libstack/tester"
cd ../tester
yarn build || EXIT_STATUS=$?

exit $EXIT_STATUS