# Services-Registery

### Register a new service
1. In the *_docker-compose.yml_* file add new service by appending the service spec to the end <br>
   ```
    <service-name>:
    image: "<docker-image-url>"
    env_file:
      - .envs/.<service-name>
    ports:
      - "<port>:<port>"
   ``` 
   *NB: Ensure the port your  using isn't alreday in use* <br>
   You can omit the env_file if your application is not using any environment variables, as simpe as
   ```
    <service-name>:
    image: "<docker-image-url>" 
    ports:
      - "<port>:<port>"
   ``` 
2. If your application made use of an env_file then open the *_init.sh_* file and add your <service-name> above to the array on line 4

3. You can now create a PR for and for your services to spin up

4. Now the service spins up but you would not be able to view anything because app running on any port apart from the default isn't visibe outside the box. So you'll have to add this service to the [turntabl API Gateway] (https://github.com/idawud/TurntablAPIGateway.git). You can clone this repo and create a PR after making these additions
    1. Open the src/main/java/io/tuntabl/TurntablApiGatewayApplication.java
    2. If your service is an API or only Endpoint, then you should add security layer for access using OPEN ID Connect by modifying this file to add route
    *NB: use <service-name> above* 
     ```
     .route("<service-name> ",
            r -> r.path("/<service-name> /**")
                .filters(f -> f.rewritePath("/<service-name> /(?<segment>.*)", "/${segment}")
                        .filter(JWTValidationFilter.apply(JWTValidationFilter.newConfig())))
                .uri("http://<service-name>:<service-port>"))
     ```
    Else you can omit the security during development and add it when you're done or omit it if its a UI app by adding route as
    ```
    .route("<service-name> ",
            r -> r.path("/<service-name> /**")
                .filters(f -> f.rewritePath("/<service-name> /(?<segment>.*)", "/${segment}"))
                .uri("http://<service-name>:<service-port>"))
    ```
5. If your PR is merged you can now access the service at http://api.services.turntabl.io/<service-name>/[all the routes in this service]

### Setting the Environment Variables and running CI/CD
The primary method we use is the GitHub Action
1. Docker & ECR for images
2. Secrets
3. You can use a sample in the *_github-action-samples_* directory by just copy and pasting in a *.yml* in the dir *.github/workflows"* in your project root directory.
4. You can check in the Action tab of your GitHub Repo for each change whetehr successful or not