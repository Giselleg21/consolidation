# Django News Application

A role-based news publishing platform built with Django and Django REST Framework. This capstone project brings together user authentication, article publishing and approval, newsletters, subscriptions, API access, automated tests, Sphinx documentation, and Docker configuration.

**Repository:** [Giselleg21/consolidation](https://github.com/Giselleg21/consolidation)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [User Roles](#user-roles)
- [Articles](#articles)
- [Article Approval](#article-approval)
- [Newsletters](#newsletters)
- [Subscriptions](#subscriptions)
- [Signals](#signals)
- [Database Models](#database-models)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Running Tests](#running-tests)
- [Running the Application](#running-the-application)
- [REST API](#rest-api)
- [Docker](#docker)
- [Sphinx Documentation](#sphinx-documentation)
- [Email Notifications](#email-notifications)
- [Security](#security)
- [Version Control](#version-control)

## Overview

The Django News Application is a web-based news publishing platform that allows journalists to create articles, editors to review and approve content, publishers to manage their publications, and readers to access news and subscribe to publishers and journalists.

The application implements role-based access control to ensure that users can only access functionality permitted by their roles. It also includes a REST API, database integration, email notification functionality, automated tests, and project documentation.

This project was developed as a Django capstone application. It demonstrates user authentication, role-based access control, article and newsletter management, subscriptions, editor approval, email notifications, and a RESTful API.

The application uses **MariaDB/MySQL** as its database.

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

Users can:

* Register for an account.
* Log in and log out.
* Select a role during registration.
* Be automatically assigned to the appropriate Django group.
* Access functionality based on their assigned role.

The application uses a custom `CustomUser` model based on Django's `AbstractUser`.

### Role-Based Permissions

The application uses Django groups and permissions for the different user roles.

#### Reader

Readers can view approved articles and newsletters and subscribe to publishers and individual journalists. They can access content relevant to their subscriptions.

Readers can:

* View approved articles.
* View newsletters.
* Subscribe to publishers.
* Subscribe to journalists.
* View articles from their subscriptions.

Readers cannot create, edit, delete, or approve articles.

#### Journalist

Journalists can create and manage articles and newsletters. Articles must be approved by an editor before becoming available to readers. Journalists can also publish independently or associate their articles with a publisher, depending on the application workflow.

Journalists can:

* Create articles.
* View articles.
* Update articles.
* Delete articles.
* Publish articles independently.
* Create newsletters.
* Update newsletters.
* Delete newsletters.
* Add articles to newsletters.
* Remove articles from newsletters.

New articles created by journalists require editor approval before being publicly available if they are published by a registered publisher. Journalists can also choose to publish their articles independently.

#### Editor

Editors can review articles, approve submitted content, and manage articles and newsletters according to their assigned permissions.

Editors can:

* View articles awaiting approval.
* Approve articles.
* Update articles.
* Delete articles.
* Create, edit and delete their own newsletters.
* View, update, and delete newsletters associated with their publication.

Editors are responsible for reviewing articles before they become approved.

#### Publisher

Publishers can manage their publications, assign journalists and editors, and access content associated with their publication.

Publishers can:

* Create a publication.
* Update their publication.
* Delete their publication.
* Manage the journalists assigned to their publication.
* Manage the editors assigned to their publication.
* View the articles associated with their publication.
* View newsletters created by journalists assigned to their publication.

Publishers are responsible for managing the journalists and editors associated with their publication.

## Articles

Articles contain:

* Title
* Content
* Author
* Creation date
* Approval status
* Publisher

Articles are initially created with `approved=False`.

An editor can review an article and approve it. Once approved, the article becomes available to readers.

If published independently, the journalist must personally publish the article before it becomes available to readers.

## Article Approval

This applies only to articles published by a registered publisher.

The application includes an editor-only article review system.

Editors can access the article review page and select an article to review. They can then approve the article.

When an article is approved:

1. The article's approval status is changed to `True`.
2. Subscribers are identified.
3. Email notifications are sent to relevant subscribers.
4. A POST request is made to the application's `/api/approved/` endpoint.

The email system uses Django's console email backend during development.

## Newsletters

Newsletters contain:

* Title
* Description
* Creation date
* Author
* Associated articles

Journalists can create, update, and delete newsletters.

Editors can view, update, and delete newsletters associated with their publication and create their own newsletters.

Multiple articles can be associated with a newsletter. Removing an article from a newsletter does not delete the article itself.

## Subscriptions

Readers can subscribe to:

* Publishers
* Individual journalists

The application uses Django `ManyToManyField` relationships to manage subscriptions.

The subscribed articles API filters approved articles according to the reader's subscriptions.

Readers can manage their subscriptions on their dashboard or via the specific newsletter or article.

## Signals

Django signals are used for automatic application behaviour.

The application includes signals for:

* Automatically assigning users to their role-based group when they register.
* Detecting when an article changes from unapproved to approved.
* Sending email notifications after an article is approved.
* Sending approval information to the application's API endpoint.

The signals are loaded through the `NewsConfig.ready()` method.

## Database Models

The main models are:

### CustomUser

Extends Django's `AbstractUser` and includes:

* Role
* Publisher subscriptions
* Journalist subscriptions

### Publisher

Contains:

* Name
* Owner
* Journalists
* Editors

The Publisher model allows a publisher to manage the journalists and editors associated with their publication.

### Article

Contains:

* Title
* Content
* Author
* Creation date
* Approval status
* Publisher

### Newsletter

Contains:

* Title
* Description
* Creation date
* Author
* Articles

## Technology Stack

- **Programming Language:** Python
- **Web Framework:** Django
- **REST API:** Django REST Framework
- **Database:** MariaDB/MySQL
- **Frontend:** HTML, CSS, Bootstrap, and Django templates
- **HTTP Requests:** Requests
- **Documentation:** Sphinx
- **Containerisation:** Docker
- **Version Control:** Git and GitHub

Dependency versions are specified in `requirements.txt`.

## Project Structure

The project follows Django's standard project and application structure. The repository folder is named `consolidation`.

```text
consolidation/
│
├── news/
│   ├── management/
│   │   └── commands/
│   ├── migrations/
│   ├── static/
│   │   └── News/
│   ├── templates/
│   │   └── News/
│   ├── __init__.py
│   ├── admin.py
│   ├── api_urls.py
│   ├── api_views.py
│   ├── apps.py
│   ├── forms.py
│   ├── models.py
│   ├── serializers.py
│   ├── signals.py
│   ├── tests.py
│   ├── urls.py
│   └── views.py
│
├── news_application/
│   ├── settings.py
│   ├── urls.py
│   ├── asgi.py
│   └── wsgi.py
│
├── docs/
├── .dockerignore
├── .gitignore
├── Dockerfile
├── manage.py
├── requirements.txt
└── README.md
```

Python files, classes, functions, and variables follow standard Python naming conventions where applicable.

## Installation

The following instructions explain how to install and run the project from a fresh computer. They assume macOS and use MariaDB/MySQL. On Windows or Linux, the same steps apply, but use your system's package manager to install MariaDB/MySQL and use the virtual environment activation command shown in step 2.

To run the project in Docker instead, see the [Docker](#docker) section.

### 1. Clone the Repository

Open a terminal and clone the GitHub repository:

```bash
git clone https://github.com/Giselleg21/consolidation.git
```

Enter the project folder:

```bash
cd consolidation
```

All remaining commands in this README should be run from inside this `consolidation` folder unless stated otherwise.

### 2. Create a Virtual Environment

Create a Python virtual environment:

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

The terminal should now show `(myenv)` before the command prompt.

### 3. Install the Required Python Packages

The project includes a `requirements.txt` file containing the Python packages and versions required by the application.

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

The `requirements.txt` file contains the versions that are known to work with this project. For example:

```text
Django==4.2.30
djangorestframework==3.16.1
mysqlclient==2.2.7
requests==2.32.5
```

Using specific package versions ensures that the same compatible versions are installed rather than automatically installing the newest available versions, which could introduce compatibility problems.

If `mysqlclient` fails to install on macOS, make sure MariaDB and the build tools are installed (see step 4).

### 4. Install MariaDB

If MariaDB is not already installed, install it using Homebrew:

```bash
brew install mariadb
```

The `pkg-config` package may also be required when installing `mysqlclient`:

```bash
brew install pkg-config
```

Check that MariaDB is available:

```bash
mariadb --version
```

Check whether the MariaDB server is running:

```bash
mariadb-admin ping
```

The expected response is similar to:

```text
mysqld is alive
```

If MariaDB is not running, start it with:

```bash
brew services start mariadb
```

### 5. Create the MariaDB Database

Open the MariaDB command line:

```bash
sudo mariadb
```

Create the database:

```sql
CREATE DATABASE news_database;
```

Create a database user:

```sql
CREATE USER 'news_user'@'localhost' IDENTIFIED BY 'news_password';
```

Give the user access to the project database:

```sql
GRANT ALL PRIVILEGES ON news_database.* TO 'news_user'@'localhost';
```

Apply the privileges:

```sql
FLUSH PRIVILEGES;
```

Exit MariaDB:

```sql
EXIT;
```

You can use a different database name, username, and password. If you do, update the Django settings in step 6 to match.

### 6. Configure the Database in Django

Open:

```text
news_application/settings.py
```

The database configuration should point to the MariaDB database:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'news_database',
        'USER': 'news_user',
        'PASSWORD': 'news_password',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

The database credentials should be changed if different credentials are used on another computer.

For a production deployment, database passwords should be stored securely using environment variables rather than being committed directly to source control.

### 7. Apply the Database Migrations

Make sure the virtual environment is activated, then run:

```bash
python manage.py migrate
```

This creates the required database tables in MariaDB.

### 8. Create the Application Groups

The application uses Django groups for its role-based permissions. Run:

```bash
python manage.py create_groups
```

This creates the required:

* Reader group
* Journalist group
* Editor group
* Publisher group

and assigns the appropriate permissions.

### 9. Create an Administrator Account

Create a Django superuser:

```bash
python manage.py createsuperuser
```

Follow the prompts to enter:

* Username
* Email address
* Password

The superuser can then access the Django administration site.

### 10. Check the Project

Run Django's system check:

```bash
python manage.py check
```

The expected result is:

```text
System check identified no issues (0 silenced).
```

## Running Tests

Run the automated tests:

```bash
python manage.py test
```

The tests should complete successfully before using the application. The project currently has 38 automated tests, all of which pass successfully.

Review the test output and error messages to identify any configuration problems or failing tests.

## Running the Application

Start Django's development server:

```bash
python manage.py runserver
```

The application will normally be available at [http://127.0.0.1:8000/](http://127.0.0.1:8000/). Open this address in a web browser.

The available pages and functionality depend on the user's authentication status and assigned role.

### Main Application URLs

| URL | Purpose |
|---|---|
| `/` | Home page |
| `/register/` | Register a new Reader, Journalist, Editor, or Publisher |
| `/login/` | Log into an existing account |
| `/articles/` | View articles |
| `/articles/create/` | Create an article |
| `/newsletters/` | View newsletters |
| `/newsletters/create/` | Create a newsletter |
| `/editor/articles/` | Editor article review page |
| `/publisher/create/` | Create a publication as a Publisher |
| `/publisher/journalists/` | Manage journalists assigned to a publication |
| `/publisher/editors/` | Manage editors assigned to a publication |
| `/publisher/view/` | View the Publisher's publication |
| `/publisher/update/` | Update the Publisher's publication |
| `/publisher/delete/` | Delete the Publisher's publication |
| `/admin/` | Django administration site |

## REST API

The application uses Django REST Framework to provide API functionality. The API includes endpoints for article retrieval and management, subscriber-related article retrieval, article approval, and token authentication.

### API Serializers

The application includes serializers for:

* Users
* Publishers
* Articles
* Newsletters

The `ArticleSerializer` includes:

* ID
* Title
* Content
* Author
* Creation date
* Approval status
* Publisher

The author, creation date, and approval status are controlled by the application rather than being freely supplied by API users.

### API Endpoints

| Endpoint | Method | Purpose |
|---|---|---|
| `/api/token/` | POST | Obtain an authentication token |
| `/api/articles/` | GET | View approved articles |
| `/api/articles/` | POST | Create an article as a journalist |
| `/api/articles/<id>/` | GET | View an approved article |
| `/api/articles/<id>/` | PUT | Update an article |
| `/api/articles/<id>/` | DELETE | Delete an article |
| `/api/articles/subscribed/` | GET | View articles from reader subscriptions |
| `/api/approved/` | POST | Receive article approval information |

Replace `<id>` with the relevant article ID. Access to endpoints depends on the application's configured authentication and permission rules.

### Token Authentication

Authentication is handled using Django REST Framework token authentication.

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

## Docker

The project includes a Dockerfile to containerise the Django News Application using Python 3.9.

### Prerequisites

* **Git** and **Docker** must be installed.
* **Docker must be running before you build.** The `docker build` and `docker run` commands need the Docker daemon.
  * **macOS and Windows:** open **Docker Desktop** and wait until it shows that Docker is running.
  * **Linux:** Docker Desktop is not required, but the Docker Engine service must be running (for example, `sudo systemctl start docker`).

To confirm Docker is running, run:

```bash
docker info
```

If this prints a "Cannot connect to the Docker daemon" error, Docker is not running yet.

### 1. Clone the Repository and Enter the Project Folder

If you have not already done so, clone the repository and enter the folder that contains the Dockerfile:

```bash
git clone https://github.com/Giselleg21/consolidation.git
cd consolidation
```

Check that the Dockerfile is in the current folder (macOS/Linux):

```bash
ls Dockerfile
```

On Windows PowerShell, use `dir Dockerfile`. All Docker commands below must be run from this `consolidation` folder.

### 2. Build the Docker Image

With Docker running, run:

```bash
docker build -t consolidation .
```

The Dockerfile installs the system dependencies required for database connectivity, installs the Python packages listed in `requirements.txt`, and copies the application into the container.

### 3. Run the Container

The container does not include a database. Before running it, MariaDB/MySQL must be installed and running on your computer, and the database must already be created and migrated (see [Installation](#installation), steps 4, 5, 7 and 8).

Start the application, telling it where the database is with `DB_HOST`:

```bash
docker run -d \
    --name consolidation-test \
    -p 8000:8000 \
    -e DB_HOST=host.docker.internal \
    consolidation
```

(On Windows PowerShell, put the command on one line: `docker run -d --name consolidation-test -p 8000:8000 -e DB_HOST=host.docker.internal consolidation`.)

The application will be available at [http://127.0.0.1:8000/](http://127.0.0.1:8000/).

The container runs Django's development server on port `8000`, with automatic code reloading disabled.

### Database Configuration in Docker

The application uses MariaDB/MySQL. Inside a container, `localhost` refers to the container itself, not your computer, so the container cannot find a database running on your computer through `localhost`.

To solve this, `settings.py` reads the database host from the `DB_HOST` environment variable and uses `localhost` when it is not set. This means running the application normally (outside Docker) needs no extra configuration.

* **Docker Desktop (macOS and Windows):** use `-e DB_HOST=host.docker.internal`, as shown above, to reach the database on your computer.
* **Linux (Docker Engine):** `host.docker.internal` is not available by default. Add `--add-host=host.docker.internal:host-gateway` to the `docker run` command, or set `DB_HOST` to your computer's IP address.
* **Connection errors:** if the container stops immediately, run `docker logs consolidation-test`. A "Can't connect" error means the database is not running or `DB_HOST` is wrong. If the error says access is denied, the database user may not be allowed to connect from outside `localhost`; grant it access using a host that matches your setup.

### Useful Docker Commands

Check running containers:

```bash
docker ps
```

View application logs:

```bash
docker logs consolidation-test
```

Stop the container:

```bash
docker stop consolidation-test
```

Remove the container:

```bash
docker rm consolidation-test
```

**Note:** This Docker configuration is intended for development and assessment. Django's development server should be replaced with a production-ready server before deploying the application publicly.

## Sphinx Documentation

The project includes Sphinx documentation in the `docs/` directory.

To generate the HTML documentation, run the following command from the project root (the `consolidation` folder):

```bash
python -m sphinx -b html docs docs/_build/html
```

Once generated, open the following file in your browser:

```text
docs/_build/html/index.html
```

The documentation provides a structured reference for the project and its code.

## Email Notifications

When an article is approved, the application sends email notifications to relevant subscribers.

During development, the application uses Django's console email backend. This means emails are displayed in the terminal where the development server is running rather than being sent through an external email service.

## Security

The following security practices should be followed when developing or deploying the application:

- Keep database credentials and secret keys secure.
- Do not commit passwords, API tokens, or other sensitive information to GitHub.
- Apply authentication and role-based permissions to protected functionality.
- Use a dedicated database user with appropriate permissions.
- Do not use Django's development server for production deployments.
- Review Django's deployment checklist before making the application publicly accessible.

## Version Control

The source code, configuration files, migrations, templates, static files, tests, and documentation are maintained in the following GitHub repository:

[https://github.com/Giselleg21/consolidation](https://github.com/Giselleg21/consolidation)

Sensitive files such as virtual environments, local SQLite databases, environment files, Python cache files, and operating-system files are excluded using `.gitignore`.
