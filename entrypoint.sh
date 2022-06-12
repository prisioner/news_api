#!/bin/sh

wait_for_db_load () {
  echo "Waiting for postgres start"
  until psql -h $DB_HOST -U postgres -c 'SELECT 1'; do sleep 1; done;
}

check_db_user () {
  printf "Check DB User[%s] ... " ${DB_USERNAME}

  if [ $(psql -qtA -h ${DB_HOST} -p ${DB_PORT} -U postgres -c "\du ${DB_USERNAME}" | cut -d "|" -f 1) ]; then
    echo -ne "exist\n"
  else
    psql -h ${DB_HOST} -p ${DB_PORT} -U postgres -c "CREATE ROLE ${DB_USERNAME} WITH LOGIN SUPERUSER PASSWORD '${DB_PASSWORD}'"
    echo -ne "created\n"
  fi
}

check_db () {
  printf "Check DB[%s] ... " ${DB_NAME}
  if psql -lqt -h ${DB_HOST} -p ${DB_PORT} -U postgres | cut -d "|" -f 1 | grep -qw ${DB_NAME}; then
    echo -ne "exist\n"
  else
    psql -h ${DB_HOST} -p ${DB_PORT} -U postgres -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USERNAME}"
    echo -ne "created\n"
  fi
}

check_test_db () {
  printf "Check test DB[%s] ... " ${DB_TEST_NAME}
  if psql -lqt -h ${DB_HOST} -p ${DB_PORT} -U postgres | cut -d "|" -f 1 | grep -qw ${DB_TEST_NAME}; then
    echo -ne "exist\n"
  else
    psql -h ${DB_HOST} -p ${DB_PORT} -U postgres -c "CREATE DATABASE ${DB_TEST_NAME} OWNER ${DB_USERNAME}"
    echo -ne "created\n"
  fi
}

initialize_db () {
  echo "Initialize DB:"

  if [ ${RAILS_ENV} == "production" ]; then
    echo "Skip for production"
    return 0
  fi

  wait_for_db_load
  check_db_user
  check_db
  check_test_db

  echo "Migration[development]:"
  RAILS_ENV=development bundle exec rails db:migrate
  echo "Migration[test]:"
  RAILS_ENV=test bundle exec rails db:migrate
}

printf "Run with %s environment\n" ${RAILS_ENV}

echo "Bundle install:"
bundle install
echo ""

initialize_db

echo "Migration has been done!"

echo "Running webserver..."
rm -f tmp/pids/server.pid

$@
