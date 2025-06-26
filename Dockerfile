# Use official Python 3.12.11 slim image
FROM python:3.12.11-slim

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CODE_SERVER_VERSION=4.90.1
ENV PASSWORD=secret  

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl wget git unzip gnupg ca-certificates \
    libglib2.0-0 libnss3 libx11-xcb1 libxcomposite1 \
    libxcursor1 libxdamage1 libxi6 libxtst6 \
    libatk-bridge2.0-0 libgtk-3-0 libasound2 \
    libxrandr2 libxss1 libxkbcommon0 libxshmfence1 \
    python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb -o code-server.deb \
    && dpkg -i code-server.deb || apt-get install -f -y \
    && rm code-server.deb

# Create non-root user 'coder'
RUN useradd -m coder

# Switch to user 'coder'
USER coder
WORKDIR /home/coder

# Clone the repo as 'coder' user (files owned by coder)
RUN git clone https://github.com/google-a2a/a2a-samples.git -b main --depth 1 /home/coder/a2a-samples

# Switch back to root to copy files and fix permissions
USER root

# Copy your local files into the container
COPY currency_agent.py /home/coder/a2a-samples/samples/python/agents/langgraph/app/currency_agent.py
COPY .env /home/coder/a2a-samples/samples/python/agents/langgraph/.env

# Fix ownership so 'coder' can edit all files, including copied ones
RUN chown -R coder:coder /home/coder/a2a-samples

# Switch back to coder
USER coder

# Setup python virtual environment and install dependencies
WORKDIR /home/coder/a2a-samples
RUN python3 -m venv .venv \
    && .venv/bin/pip install --upgrade pip \
    && .venv/bin/pip install -r samples/python/requirements.txt

# Install langgraph package in editable mode
WORKDIR /home/coder/a2a-samples/samples/python/agents/langgraph
RUN /home/coder/a2a-samples/.venv/bin/pip install -e .

# Set default working directory back to coder home
WORKDIR /home/coder

# Expose necessary ports
EXPOSE 8443
EXPOSE 10000-10099

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8443"]
