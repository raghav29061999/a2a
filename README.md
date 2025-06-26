# A2A Protocol Demo — Dockerized

This Docker image provides a preconfigured environment to test two example agents from the [A2A Project](https://github.com/google-a2a/a2a-samples):

## 🔧 Dockerfile Details
    The Dockerfile provided in this repository does the following:

    Installs System Dependencies: Installs the necessary packages to run Python and code-server.

    Installs code-server: Web-based IDE (VS Code) for working inside the container.

    Sets Up Python Virtual Environment: Installs Python dependencies and sets up the environment for the agents.

    Clones the A2A Project: Downloads the example agents from GitHub.

    Copies Your Files: Copies your currency_exchange.py and .env files to the container.

    Exposes Ports: Exposes ports for code-server and other services.

    Starts code-server: Starts the VS Code environment when the container is launched.

- **HelloWorld Agent**
- **LangGraph Agent** (including currency conversion)

It also includes a web-based VS Code environment via port 8443, allowing easy editing and testing of code inside the container. 
>http://localhost:8443/

---

## 🚀 Getting Started

### 1. **Build the Docker Image**

To get started, build the Docker image from the provided `Dockerfile`:

```bash
docker build -t my-codeserver-image . 
docker run -d --name my-codeserver-container -p 8443:8443 -p 10000-10099:10000-10099 my-codeserver-image
```



## 🚀 Access the VS Code Interface
    http://localhost:8443
    Login password: secret

## 🔧 Working with Agents
    1. docker exec -it my-codeserver-container bash
    2. cd a2a-samples
    3. source ./.venv/bin/activate

### 🧑‍💻 HelloWorld Agent
    
    1. python samples/python/agents/helloworld/__main__.py 
    2. python samples/python/agents/helloworld/test_client.py

### 🌍 LangGraph Agent
1. Set Up the .env File: Before starting the LangGraph agent, you need to add your Gemini API key to the .env file in the following path: 
    >samples/python/agents/langgraph/.env

2. Start the LangGraph Server: Navigate to the langgraph app directory and start the server:
    >cd samples/python/agents/langgraph/app
    >python __main__.py

3. Test LangGraph Agent in a New Terminal: In a new terminal (with the virtual environment activated), you can test the LangGraph agent with the following examples:
    > Run test client: python samples/python/agents/langgraph/app/test_client.py

    >  Currency Exchange Example: python samples/python/agents/langgraph/app/currency_exchange.py --question "10 GBP to INR"
    
    >  Invalid Query Example (Currency Agent): python samples/python/agents/langgraph/app/currency_exchange.py --question "Temperature in Delhi"

## 📋 Full Tutorial & Documentation
For a more detailed tutorial and documentation, please refer to the full guide here:
> https://a2aproject.github.io/A2A/latest/tutorials/python/1-introduction/

