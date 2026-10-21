# Use a lightweight Python 3.9 image as the base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies required for mysqlclient
# and other packages that may need to be compiled
RUN apt-get update \
    && apt-get install -y \
        pkg-config \
        default-libmysqlclient-dev \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container
COPY requirements.txt .

# Install the Python packages required by the project
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project files into the container
COPY . .

# Document that the application uses port 8000
EXPOSE 8000

# Start the Django development server and make it
# accessible from outside the container
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000", "--noreload"]

