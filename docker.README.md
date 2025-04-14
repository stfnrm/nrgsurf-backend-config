# Building and Pushing a Docker Image from a Running Container

## Why This Approach?
Normally, Docker images are built using a Dockerfile, but in this case, the project involves **many volume mounts**. Managing all these mounts through COPY and ADD commands in the Dockerfile can be complex and error-prone.

## Prerequisites
Before starting this process, make sure you have:

- **Docker** installed and properly configured on your system
- **Docker Compose** installed (for the multi-container setup)
- An account on a Docker image repository:
  - [Docker Hub](https://hub.docker.com/) (free public repositories or paid private repositories)
  - Or alternatives like:
    - [GitHub Container Registry](https://ghcr.io/)
    - [Amazon ECR](https://aws.amazon.com/ecr/)
    - [Google Container Registry](https://cloud.google.com/container-registry)
    - [Azure Container Registry](https://azure.microsoft.com/en-us/products/container-registry)
- Docker CLI logged in to your repository (`docker login`)
- Git installed (to clone the repository)

Instead of manually handling file transfers, we:
1. **Run the container** with docker compose up --build to set up everything.
2. **Commit the running container** to capture its complete state, including mounted files, installed dependencies, and configurations.
3. **Tag and push the image** to Docker Hub for easy redeployment.

## Step-by-Step Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/citrineos/citrineos-core.git
```

### 2. Editing the dockerfile
```bash
cd citrineos-core/DirectusExtensions
```

Edit the Dockerfile named directus.Dockerfile as follows:
```Dockerfile
FROM directus/directus:10.10.5

# Switch to root for installation steps
USER root

COPY tsconfig.build.json /directus

# Charging stations bundle setup
COPY charging-stations-bundle/tsconfig.json /directus/extensions/directus-extension-charging-stations-bundle/tsconfig.json
COPY charging-stations-bundle/package.json /directus/extensions/directus-extension-charging-stations-bundle/package.json
COPY charging-stations-bundle/src /directus/extensions/directus-extension-charging-stations-bundle/src

# Install and build the extension
RUN npm install --prefix /directus/extensions/directus-extension-charging-stations-bundle && \
   npm run build --prefix /directus/extensions/directus-extension-charging-stations-bundle

# Copy configuration
COPY /data/directus/ /directus
COPY directus-env-config.cjs /directus/config.cjs

# Create uploads directory and set permissions
RUN mkdir -p /directus/uploads && \
   chown -R node:node /directus/uploads && \
   chmod 755 /directus/uploads

# Switch back to node user
USER node
```

In `.dockerignore` file remove this line `**/*.cjs` which is present in the same directory.

Copy the **Data** folder and **directus-env-config.cjs file** from the Server folder which is presented at the root directory to this DirectusExtensions.

That's it! You're all set to build the image.

### 3. Build and Start the Containers
**NOTE**: In directus Service, just remove the volume block in docker compose file because we already passed those files during docker building.

```bash
sudo docker compose up --build
```

This command sets up the environment with all required dependencies and volume-mounted files.

### 4. Identify the Running Container
Open a new terminal and run:
```bash
docker ps
```

Copy the **container ID** or **name** of the running container.

### 5. Create a New Image from the Running Container
Since the container already has everything set up correctly, we commit it as a new image:

```bash
docker commit <citrineos-container_id_or_name> yourregistry/citrine:<tag>

docker commit <directus-container_id_or_name> yourregistry/directus:<tag>
```

### 6. Push the Image to Docker Hub
```bash
docker push yourregistry/citrine:<tag>

docker push yourregistry/directus:<tag>
```

### 7. Verify the Image on Docker Hub
Check your repository on Docker Hub to confirm the upload.

## Advantages of This Approach
✅ **Simplifies Image Creation** – No need to manually copy multiple files into the image.  
✅ **Captures the Full State** – Ensures the image includes all configurations and dependencies.  
✅ **Faster Deployment** – The committed image is ready to run without extra setup.

This workflow is ideal when handling **complex projects with many mounted volumes**. Let me know if you need any refinements! 🚀
