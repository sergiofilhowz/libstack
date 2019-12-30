EXIT_STATUS=0

echo "\n\n\n###################################"
echo "Testing @libstack/data"
echo "###################################\n"
cd packages/data
yarn test || EXIT_STATUS=$?

echo "\n\n\n###################################"
echo "Testing @libstack/keycloak"
echo "###################################\n"
cd ../keycloak
yarn test || EXIT_STATUS=$?

echo "\n\n\n###################################"
echo "Testing @libstack/router"
echo "###################################\n"
cd ../router
yarn test || EXIT_STATUS=$?

echo "\n\n\n###################################"
echo "Testing @libstack/sequel"
echo "###################################\n"
cd ../sequel
yarn test || EXIT_STATUS=$?

echo "\n\n\n###################################"
echo "Testing @libstack/tester"
echo "###################################\n"
cd ../tester
yarn test || EXIT_STATUS=$?

exit $EXIT_STATUS