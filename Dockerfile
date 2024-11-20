FROM ruby:3.3.0-slim

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential libxml2-dev \
    libxslt1-dev default-libmysqlclient-dev nodejs \
    wget \
    unzip \
    curl \
    gnupg \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    libgbm-dev \
    libgconf-2-4 \
    libgtk-3-0 \
    fonts-liberation \
    libu2f-udev \
    xdg-utils \
    libdrm2 \
    chromium \
    chromium-driver \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala o ChromeDriver
RUN wget -q "https://chromedriver.storage.googleapis.com/$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip" \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver_linux64.zip

WORKDIR /app

# Copia o Gemfile e Gemfile.lock para aproveitar cache
COPY Gemfile Gemfile.lock ./

# Instala gems
RUN bundle config set force_ruby_platform true && bundle install

# Copia o restante do código para o container
COPY . .

# Define a porta de exposição
EXPOSE 3000
