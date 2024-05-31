# AppMod 07 : Migrate to Docker Containers

This is a simple app that runs PHP code to connect to a PostgreSQL database. Both the application and database are deployed via Docker containers.

## Migrate Application to Docker

### Setup Web Application (optional)

1. These labs were designed to be run in logical order, to run these labs without performing previous labs, execute the following to setup the web application:

    ```powershell
      cd C:\labfiles\microsoft-postgresql-developer-guide\sample-php-app
    
      composer update 
    
      copy .env.example.root .env
    
      php artisan config:clear
      
      php artisan migrate
    
      php artisan db:seed
    
      php artisan key:generate
    ```

### Migrate to ENV variables

1. Switch to Visual Studio Code and the opening repo directory
2. Open the `.\artifacts\sample-php-app\public\database.php` file, then update the php PostgreSQL connection environment variables:

    ```php
    $servername = getenv("DB_HOST");
    $username = getenv("DB_USERNAME");
    $password = getenv("DB_PASSWORD");
    $dbname = getenv("DB_DATABASE");
    $port = getenv("DB_PORT");
    ```

3. Open the `.\artifacts\sample-php-app\.env` file
4. Remove the following lines:

    ```php
    DB_HOST=127.0.0.1
    DB_PORT=5432
    DB_DATABASE=contosostore
    DB_USERNAME=postgres
    DB_PASSWORD=Solliance123
    ```

### Download Docker container

1. Open **Docker Desktop**, if prompted, select **OK**
2. In the agreement dialog, select the checkbox and then select  **Accept**
3. It will take a few minutes for the Docker service to start, when prompted, select **Skip tutorial**
4. Open a PowerShell window, then run the following to download a php-enabled docker container:

    ```Powershell
    docker pull php:8.2-apache
    ```

5. In the `c:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-03-00-Docker` directory, create the `Dockerfile.web` with the following:

    ```text
    # Dockerfile
    FROM php:8.2-apache
    
    RUN apt-get update && apt-get upgrade -y
    
    RUN apt update && apt install -y zlib1g-dev libpng-dev && rm -rf /var/lib/apt/lists/*
    RUN apt update && apt install -y curl
    RUN apt-get install -y libcurl4-openssl-dev
    RUN docker-php-ext-install fileinfo
    RUN docker-php-ext-install curl
    
    RUN apt-get install -y build-essential cmake zlib1g-dev libcppunit-dev git subversion wget && rm -rf /var/lib/apt/lists/*
    
    RUN wget https://www.openssl.org/source/openssl-3.2.0.tar.gz -O - | tar -xz
    WORKDIR /openssl-3.2.0g
    RUN ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl && make && make install

    RUN docker-php-ext-install openssl
    
    # Install Postgre PDO
    RUN apt-get install -y libpq-dev \
        && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
        && docker-php-ext-install pdo pdo_pgsql pgsql
    
    # Install Composer
    RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    
    COPY artifacts/000-default.conf /etc/apache2/sites-available/000-default.conf
    COPY artifacts/start-apache.sh /usr/local/bin
    
    RUN a2enmod rewrite
    
    COPY sample-php-app /var/www
    RUN chown -R www-data:www-data /var/www
    
    #RUN chmod 755 /usr/local/bin/start-apache.sh
    
    #CMD ["start-apache.sh"]
    
    ENV SSH_PASSWD "root:Docker!"
    RUN apt-get update \
            && apt-get install -y --no-install-recommends dialog \
            && apt-get update \
      && apt-get install -y --no-install-recommends openssh-server \
      && echo "$SSH_PASSWD" | chpasswd 
    
    COPY artifacts/sshd_config /etc/ssh/
    
    COPY artifacts/init.sh /usr/local/bin/
    
    RUN chmod u+x /usr/local/bin/init.sh
    
    EXPOSE 80 22
    
    ENTRYPOINT ["/usr/local/bin/init.sh"]
    ```

6. Run the following to create the image:

    ```PowerShell
    cd "c:\labfiles\microsoft-postgresql-developer-guide";

    docker build -t store-web --file artifacts\Dockerfile.web . 
    ```

## Migrate Database to Docker

1. Run the following to export the database:

    ```powershell
    cd "c:\labfiles\microsoft-postgresql-developer-guide";

    $username = "postgres";
    $password = "Solliance123";
    $server = "localhost";
    $database = "contosostore";
    $port = "5432";

    $env:PG_PASSWORD = $password

    pg_dump -h $server -p $port -U $username -W -F p $database > c:\temp\data.sql

    #remove the weird encoding...
    $data = get-content c:\temp\data.sql

    set-content c:\temp\data.sql $data
    ```

2. In the `c:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-03-00-Docker` directory, create a new `Dockerfile.db` docker compose file:

    ```text
    FROM postgres:16.1
    #RUN chown -R postgres:root /var/lib/postgres/
    
    ADD artifacts/data.sql /etc/postgres/data.sql
    
    ENV POSTGRES_DB contosostore
    
    RUN cp /etc/postgres/data.sql /docker-entrypoint-initdb.d
    
    EXPOSE 5432 22
    ```

3. Build the container:

    ```PowerShell
    docker build -t store-db --file artifacts\Dockerfile.db .
    ```

## Run the Docker images

1. Create the following `docker-compose.yml` docker compose file:

    ```yaml
    version: '3.8'
    services:
      web:
        image: store-web
        environment:
          - DB_DATABASE=contosostore
          - DB_USERNAME=postgres
          - DB_PASSWORD=Solliance123
          - DB_PORT=5432
          - DB_HOST=db
        ports:
          - "8080:80"
        depends_on:
          - db
      db:
        image: store-db
        restart: always
        environment:
          - POSTGRES_PASSWORD=Solliance123
          - POSTGRES_USER=postgres
          - POSTGRES_DB=contosostore
        ports:
          - "5432:5432"
      pgadmin:
        image: dpage/pgadmin4
        ports:
            - '8081:80'
        restart: always
        environment:
            - PGADMIN_DEFAULT_PASSWORD=Solliance123
            - PGADMIN_DEFAULT_EMAIL=postgres@contoso.com
        depends_on:
            - db
   ```

2. Open a new PowerShell window, run the following to create the web container:

    ```PowerShell
    cd C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-03-00-Docker

    iisreset /stop

    docker compose run --service-ports web
    ```

3. Open a new PowerShell window, run the following to create the db container:

    ```powershell
    cd C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-03-00-Docker

    stop-service postgresql-x64-14 -ea silentlycontinue
    stop-service postgresql-x64-16 -ea silentlycontinue

    docker compose run --service-ports db
    ```

4. Open a new PowerShell window, run the following to create the pgadmin container:

    ```powershell
    cd C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-03-00-Docker

    docker compose run --service-ports pgadmin
    ```

## Migrate the database

1. Use export steps in [Migrate the database](./Misc/02_MigrateDatabase) article to export the database
2. Open a browser to `http:\\localhost:8081` and the pgadmin portal
3. Login to the database using `postgres@contoso.com` and `Solliance123`
4. Right-click **Servers**, select **Register**
5. For the name, type **Postgres 16**
6. Select the **Connection** tab
7. For the host, type **localhost**
8. Select **Save**
9. Select the **contosostore** database
10. Run the exported database sql to import the database and data
11. Select the **SQL** tab, copy and then run the following query by selecting **Go**, record the count

  ```sql
  select count(*) from orders
  ```

## Test the Docker images

1. Open a browser to `http:\\localhost:8080\index.php`
2. Select **START ORDER**

  > **NOTE** If  get an error about the application not being able to connect, do the following to attempt to debug:

  - Open a new PowerShell window, run the following to start a bash shell

    ```powershell
    docker exec -it artifacts-web-1 /bin/bash
    ```

  - Run the following commands in the new bash shell, look for the database error that is displayed:

    ```bash
    cd /var/www
    
    php artisan migrate
    ```

3. Once the connection is working, refresh the page then select **START ORDER**
4. Select **Breakfast**, then select **CONTINUE**
5. Select **Bacon & Eggs**, then select **ADD**
6. Select **CHECKOUT**
7. Select **COMPLETE ORDER**
8. Switch to the PowerShell windows that started the containers, shutdown the images, press **CTRL-X** to stop the images
9. Restart the images:

    ```PowerShell
    cd C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-03-00-Docker

    docker compose up
    ```

10. Switch back to the `pgadmin` window. Attempt to re-run the `select count(*) from orders` query, notice that the database has the same orders as when it first started. This is because the container's data is lost when it is stopped/removed.

## Fix Storage persistence

1. Modify the `docker-compose.yml` docker compose file, notice how we are creating and adding a volume to the database container. We also added the pgadmin continer:

  ```yaml
  version: '3.8'
  services:
    web:
      image: store-web
      environment:
        - DB_DATABASE=contosostore
        - DB_USERNAME=postgres
        - DB_PASSWORD=root
        - DB_HOST=db
        - DB_PORT=5432
      ports:
        - "8080:80" 
    db:
      image: store-db
      restart: always
      environment:
        - POSTGRES_PASSWORD=Solliance123
        - POSTGRES_USER=postgres
        - POSTGRES_DB=contosostore
      volumes:
        - "db-volume:/var/lib/postgresql"
      ports:
        - "5432:5432"
    pgadmin:
      image: dpage/pgadmin4
      ports:
          - '8081:80'
      restart: always
      environment:
          - PGADMIN_DEFAULT_PASSWORD=Solliance123
          - PGADMIN_DEFAULT_EMAIL=postgres@contoso.com
      depends_on:
          - db
  volumes:
    db-volume:
      external: false
   ```

## Re-test the Docker images

1. Run the following:

  ```PowerShell
  stop service postgresql-x64-14 -ea silentlycontinue
  stop service postgresql-x64-16 -ea silentlycontinue

  docker compose up
  ```

2. Create some more orders
3. Restart the containers. Notice that data is now persisted. 
4. It is now up to the administrators to ensure the database volume is maintained for the length of the solution. If this volume is ever deleted, the data will be lost!

## Save the images to Azure Container Registry (ACR)

1. Open the Azure Portal
2. Browse to the **pgsqldevSUFFIX** Azure Container Registry
3. Under **Settings**, select **Access keys**
4. Copy the username and password
5. In the **pgsqldevSUFFIX-win11** virtual machine, switch to a powershell window and run the following:

    ```powershell
    az login --identity

    $acrList = $(az acr list -o json | ConvertFrom-Json)
    $acrName = $acrList[0].name
    
    $creds = $(az acr credential show --name $acrname -o json | ConvertFrom-Json)
    
    $username = $creds.username
    $password = $creds.passwords[0].value
    
    docker login "$($acrName).azurecr.io" -u $username -p $password
    
    docker tag dpage/pgadmin4 "$($acrName).azurecr.io/dpage/pgadmin4"
    
    docker tag store-db "$($acrName).azurecr.io/store-db"
    
    docker tag store-web "$($acrName).azurecr.io/store-web"
    
    docker push "$($acrName).azurecr.io/store-db"
    
    docker push "$($acrName).azurecr.io/store-web"
    
    docker push "$($acrName).azurecr.io/dpage/pgadmin4"
    ```

6. Switch to the Azure Portal
7. Browse to the `pgsqldevSUFFIX` Azure Container Registry.
8. Under **Services**, select **Repositories**, three images should display in the Azure Container Registry that we will use later for deployment to other container based runtimes.
