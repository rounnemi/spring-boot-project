# Construire une image Jenkins prête pour Docker‑in‑Docker, kubectl, Helm et SonarScanner
FROM jenkins/jenkins:latest-jdk21

USER root

# ─────────────────────────────────────────────
# 1. Prérequis communs
# ─────────────────────────────────────────────
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl gnupg lsb-release unzip tar && \
    rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────
# 2. Docker CLI
# ─────────────────────────────────────────────
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
       https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) \
          signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
          https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
          > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────
# 3. kubectl (dernière version stable)
# ─────────────────────────────────────────────
RUN curl -L --output /usr/local/bin/kubectl \
       https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl  # :contentReference[oaicite:0]{index=0}

# ─────────────────────────────────────────────
# 4. Helm (utile pour vos déploiements K8s)
# ─────────────────────────────────────────────
ARG HELM_VERSION=v3.14.4
RUN curl -L --output /tmp/helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xzvf /tmp/helm.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    rm -rf /tmp/*

# ─────────────────────────────────────────────
# 5. SonarScanner CLI (facultatif mais pratique)
# ─────────────────────────────────────────────
RUN curl -L --output /tmp/sonar-scanner.zip \
       https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip && \
    unzip /tmp/sonar-scanner.zip -d /opt && \
    ln -s /opt/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm /tmp/sonar-scanner.zip

# Retour à l’utilisateur jenkins
USER jenkins

# Plugins Jenkins : Kubernetes & SonarQube
RUN jenkins-plugin-cli --plugins \
      "kubernetes:latest sonar:latest"
