# Django News Application

A role-based news publishing platform built with Django and Django REST Framework. This capstone project brings together user authentication, article publishing and approval, newsletters, subscriptions, API access, automated tests, Sphinx documentation, and Docker configuration.

**Repository:** [Giselleg21/consolidation](https://github.com/Giselleg21/consolidation)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [User Roles](#user-roles)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Database Configuration](#database-configuration)
- [Running the Application](#running-the-application)
- [REST API](#rest-api)
- [Running Tests](#running-tests)
- [Docker](#docker)
- [Sphinx Documentation](#sphinx-documentation)
- [Security](#security)

## Overview

The Django News Application is a web-based news publishing platform that allows journalists to create articles, editors to review and approve content, publishers to manage their publications, and readers to access news and subscribe to publishers and journalists.

The application implements role-based access control to ensure that users can only access functionality permitted by their roles. It also includes a REST API, database integration, email notification functionality, automated tests, and project documentation.

## Features

- Custom user model and user authentication.
- Role-based access control and Django groups.
- Article creation, editing, deletion, and approval.
- Editorial review and approval workflow.
- Publisher management.
- Journalist and editor assignments to publishers.
- Newsletter creation and management.
- Reader subscriptions to publishers and journalists.
- Subscriber-focused article retrieval.
- Email notification functionality for approved articles.
- Django REST Framework API endpoints.
- Token-based API authentication.
- MariaDB/MySQL database integration.
- Automated testing.
- Sphinx documentation.
- Docker configuration.

## User Roles

### Reader

Readers can view approved articles and newsletters and subscribe to publishers and individual journalists. They can access content relevant to their subscriptions.

### Journalist

Journalists can create and manage articles and newsletters. Articles must be approved by an editor before becoming available to readers. Journalists can also publish independently or associate their articles with a publisher, depending on the application workflow.

### Editor

Editors can review articles, approve submitted content, and manage articles and newsletters according to their assigned permissions.

### Publisher

Publishers can manage their publications, assign journalists and editors, and access content associated with their publication.

## Technology Stack

- **Programming Language:** Python
- **Web Framework:** Django
- **REST API:** Django REST Framework
- **Database:** MariaDB/MySQL
- **Frontend:** HTML, CSS, Bootstrap, and Django templates
- **Documentation:** Sphinx
- **Containerisation:** Docker
- **Version Control:** Git and GitHub

Dependency versions are specified in `requirements.txt`.

## Project Structure

```text
consolidation/
├── News/
│   ├── migrations/
│   ├── static/
│   ├── templates/
│   ├── admin.py
│   ├── api_views.py
│   ├── apps.py
│   ├── forms.py
│   ├── models.py
│   ├── serializers.py
│   ├── signals.py
│   ├── tests.py
│   ├── urls.py
│   └── views.py
├── News_application/
│   ├── settings.py
│   ├── urls.py
│   ├── asgi.py
│   └── wsgi.py
├── docs/
├── .dockerignore
├── .gitignore
├── Dockerfile
├── manage.py
├── requirements.txt
└── README.md
```

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Giselleg21/consolidation.git
cd consolidation
```

### 2. Create a Virtual Environment

```bash
python3 -m venv myenv
```

Activate the virtual environment on macOS or Linux:

```bash
source myenv/bin/activate
```

On Windows:

```powershell
myenv\Scripts\activate
```

### 3. Install Dependencies

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

If `mysqlclient` fails to install on macOS, ensure that the required MariaDB/MySQL client libraries and build tools are installed.

### 4. Configure the Database

Install and start MariaDB or MySQL if it is not already running.

Create a database and database user for the application. Configure the database connection using the settings implemented in `News_application/settings.py`.

### 5. Apply Migrations

After configuring the database, run:

```bash
python manage.py migrate
```

If the project's custom `create_groups` management command is available, initialise the application groups with:

```bash
python manage.py create_groups
```

Create an administrator account:

```bash
python manage.py createsuperuser
```

Check the project configuration:

```bash
python manage.py check
```

## Database Configuration

The application uses MariaDB/MySQL as its database.

Before running migrations, ensure that the database server is running and that the database and database user configured in `News_application/settings.py` exist.

A database administrator can create a database and dedicated user using commands such as:

```sql
CREATE DATABASE your_database_name;

CREATE USER 'your_database_user'@'localhost'
IDENTIFIED BY 'choose_a_strong_password';

GRANT ALL PRIVILEGES ON your_database_name.*
TO 'your_database_user'@'localhost';

FLUSH PRIVILEGES;
```

Replace the example database name, username, and password with your own values. Ensure that the database settings in the Django project match your configuration.

## Running the Application

Start the Django development server:

```bash
python manage.py runserver
```

Open the application in your browser:

[http://127.0.0.1:8000/](http://127.0.0.1:8000/)

The available pages and functionality depend on the user's authentication status and assigned role.

## REST API

The application uses Django REST Framework to provide API functionality.

The API includes endpoints for article retrieval and management, subscriber-related article retrieval, article approval, and token authentication.

### API Endpoints

| Endpoint | Method | Description |
|---|---|---|
| `/api/token/` | POST | Obtain an authentication token |
| `/api/articles/` | GET | Retrieve approved articles |
| `/api/articles/` | POST | Create an article where permitted |
| `/api/articles/<id>/` | GET | Retrieve an article by ID |
| `/api/articles/<id>/` | PUT | Update an article where permitted |
| `/api/articles/<id>/` | DELETE | Delete an article where permitted |
| `/api/articles/subscribed/` | GET | Retrieve articles related to a reader's subscriptions |
| `/api/approved/` | POST | Handle article-approval information |

Replace `<id>` with the relevant article ID. Access to endpoints depends on the application's configured authentication and permission rules.

### Token Authentication

Send a POST request to `/api/token/` with valid user credentials:

```json
{
    "username": "your_username",
    "password": "your_password"
}
```

For endpoints that require token authentication, include the token in the request header:

```text
Authorization: Token YOUR_TOKEN_HERE
```

Use credentials from your own local development environment. Never publish passwords or authentication tokens.

## Running Tests

Run the automated test suite using:

```bash
python manage.py test
```

You can also run Django's system checks:

```bash
python manage.py check
```

Review test output and error messages to identify any configuration problems or failing tests.

## Docker

The project includes a Dockerfile for building a container image.

Build the image from the repository root:

```bash
docker build -t consolidation .
```

If the database is running on the host machine and is configured to accept connections from the container, Docker Desktop on macOS commonly allows access through `host.docker.internal`.

Configure the database connection using the settings and configuration supported by the project. Ensure that the database is accessible from inside the container.

Useful Docker commands:

```bash
docker ps
docker logs consolidation-test
docker stop consolidation-test
docker rm consolidation-test
```

The Docker configuration is intended for development and assessment. Additional configuration is required for a secure production deployment.

## Sphinx Documentation

The project includes Sphinx documentation in the `docs/` directory.

To generate the HTML documentation, run the following command from the project root:

```bash
python -m sphinx -b html docs docs/_build/html
```

Once generated, open the following file in your browser:

```text
docs/_build/html/index.html
```

The documentation provides a structured reference for the project and its code.

## Security

The following security practices should be followed when developing or deploying the application:

- Keep database credentials and secret keys secure.
- Do not commit passwords, API tokens, or other sensitive information to GitHub.
- Apply authentication and role-based permissions to protected functionality.
- Use a dedicated database user with appropriate permissions.
- Do not use Django's development server for production deployments.
- Review Django's deployment checklist before making the application publicly accessible.

## Repository

The source code, configuration files, tests, and documentation are maintained in the following GitHub repository:

[https://github.com/Giselleg21/consolidation](https://github.com/Giselleg21/consolidation)
