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

New articles created by journalists require editor approval before being publicly available if they are published by a registered publication. Journalists can also choose to publish their articles independently.

#### Editor

Editors can review articles, approve submitted content, and manage articles and newsletters according to their assigned permissions.

Editors can:

* View articles awaiting approval.

* Approve articles.

* Update articles.

* Delete articles.

* Create, edit and delete their own nesletters.

* View, update, and delete newsletters associated with their publication.

Editors are responsible for reviewing articles before they become approved.

#### Publisher

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

consolidation/
├── News/
=======
* Create a publication.

* Update their publication.

* Delete their publication.

* Manage the journalists assigned to their publication.

* Manage the editors assigned to their publication.

* View the articles associated with their publication.

* View newsletters created by journalists assigned to their publication.

Publishers are responsible for managing the journalists and editors associated with their publication.

---

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

---

## Article Approval

This applies only to articles published by a registered publication.

The application includes an editor-only article review system.

Editors can access the article review page and select an article to review. They can then approve the article.

When an article is approved:

1. The article's approval status is changed to `True`.

2. Subscribers are identified.

3. Email notifications are sent to relevant subscribers.

4. A POST request is made to the application's `/api/approved/` endpoint.

The email system uses Django's console email backend during development.

---

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

---

## Subscriptions

Readers can subscribe to:

* Publishers

* Individual journalists

The application uses Django `ManyToManyField` relationships to manage subscriptions.

The subscribed articles API filters approved articles according to the reader's subscriptions.

Readers can manage their subscriptions on their dashboard or via the specific newsletter or article.

---

## API

The application includes a Django REST Framework API.

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

| Endpoint                    | Method | Purpose                                 |
| --------------------------- | ------ | --------------------------------------- |
| `/api/token/`               | POST   | Obtain an authentication token          |
| `/api/articles/`            | GET    | View approved articles                  |
| `/api/articles/`            | POST   | Create an article as a journalist       |
| `/api/articles/<id>/`       | GET    | View an approved article                |
| `/api/articles/<id>/`       | PUT    | Update an article                       |
| `/api/articles/<id>/`       | DELETE | Delete an article                       |
| `/api/articles/subscribed/` | GET    | View articles from reader subscriptions |
| `/api/approved/`            | POST   | Receive article approval information    |

Authentication is handled using Django REST Framework token authentication.

---

## Signals

Django signals are used for automatic application behaviour.

The application includes signals for:

* Automatically assigning users to their role-based group when they register.

* Detecting when an article changes from unapproved to approved.

* Sending email notifications after an article is approved.

* Sending approval information to the application's API endpoint.

The signals are loaded through the `NewsConfig.ready()` method.

---

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

---

# Installation and Setup

The following instructions explain how to install and run the project from a fresh computer.

The instructions below assume macOS and use MariaDB/MySQL.

## 1. Clone the Repository

Open Terminal and clone the GitHub repository:

```bash
git clone https://github.com/Giselleg21/news_application.git
```

Enter the project folder:

```bash
cd news_application
```

The project folder uses the lowercase naming convention `news_application`.

---

## 2. Create a Virtual Environment

Create a Python virtual environment:

```bash
python3 -m venv myenv
```

Activate the virtual environment:

```bash
source myenv/bin/activate
```

The terminal should now show `(myenv)` before the command prompt.

---

## 3. Install the Required Python Packages

The project includes a `requirements.txt` file containing the Python packages and versions required by the application.

Install all required dependencies using:

```bash
pip install -r requirements.txt
```

The `requirements.txt` file should contain the versions that are known to work with this project. For example:

```text
Django==4.2.30
djangorestframework==3.16.1
mysqlclient==2.2.7
requests==2.32.5
```

Using specific package versions ensures that the same compatible versions are installed rather than automatically installing the newest available versions, which could introduce compatibility problems.

---

## 4. Install MariaDB

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

---

## 5. Create the MariaDB Database

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

---

## 6. Configure the Database in Django

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

---

## 7. Apply the Database Migrations

Make sure the virtual environment is activated:

```bash
source myenv/bin/activate
```

Run the migrations:

```bash
python manage.py migrate
```

This creates the required database tables in MariaDB.

---

## 8. Create the Application Groups

The application uses Django groups for its role-based permissions.

Run:

```bash
python manage.py create_groups
```

This creates the required:

* Reader group

* Journalist group

* Editor group

* Publisher group

and assigns the appropriate permissions.

---

## 9. Create an Administrator Account

Create a Django superuser:

```bash
python manage.py createsuperuser
```

Follow the prompts to enter:

* Username

* Email address

* Password

The superuser can then access the Django administration site.

---

## 10. Check the Project

Run Django's system check:

```bash
python manage.py check
```

The expected result is:

```text
System check identified no issues (0 silenced).
```

---

## 11. Run the Tests

Run the automated tests:

```bash
python manage.py test
```

The tests should complete successfully before using the application.

The project currently has 30 automated tests, all of which pass successfully.

---

## 12. Start the Development Server

Start Django's development server:

```bash
python manage.py runserver
```

The application will normally be available at:

```text
http://127.0.0.1:8000/
```

Open this address in a web browser.

# Main Application URLs

The main pages include:

```text
/
```

Home page.

```text
/register/
```

Register a new Reader, Journalist, Editor, or Publisher.

```text
/login/
```

Log into an existing account.

```text
/articles/
```

View articles.

```text
/articles/create/
```

Create an article.

```text
/newsletters/
```

View newsletters.

```text
/newsletters/create/
```

Create a newsletter.

```text
/editor/articles/
```

Editor article review page.

```text
/publisher/create/
```

Create a publication as a Publisher.

```text
/publisher/journalists/
```

Manage journalists assigned to a publication.

```text
/publisher/editors/
```

Manage editors assigned to a publication.

```text
/publisher/view/
```

View the Publisher's publication.

```text
/publisher/update/
```

Update the Publisher's publication.

```text
/publisher/delete/
```

Delete the Publisher's publication.

```text
/admin/
```

Django administration site.

---

# Project Structure

The project follows Django's standard project and application structure.

Important directories include:

```text
news_application/

│

├── news/

>>>>>>> bdcd5a427dd9d9bbd9b59c5c6e8c477bf069d32c
│   ├── migrations/

│   ├── static/

│   │   └── News/

│   ├── templates/

│   │   └── News/

│   ├── admin.py

│   ├── apps.py

│   ├── forms.py

│   ├── models.py

│   ├── serializers.py

│   ├── signals.py

│   ├── urls.py

│   └── views.py
<<<<<<< HEAD
├── News_application/
=======

│

├── news_application/

>>>>>>> bdcd5a427dd9d9bbd9b59c5c6e8c477bf069d32c
│   ├── settings.py

│   ├── urls.py

│   ├── asgi.py

│   └── wsgi.py
<<<<<<< HEAD
├── docs/
├── .dockerignore
├── .gitignore
├── Dockerfile
├── manage.py
├── requirements.txt
└── README.md
```

## Installation
=======

│

├── manage.py

├── README.md

└── .gitignore
```

The repository/project folder uses lowercase naming (`news_application`) to follow common Python and Django naming conventions.

Python files, classes, functions, and variables follow standard Python naming conventions where applicable.

---

# Email Notifications
>>>>>>> bdcd5a427dd9d9bbd9b59c5c6e8c477bf069d32c

### 1. Clone the Repository

```bash
git clone https://github.com/Giselleg21/consolidation.git
cd consolidation
```

<<<<<<< HEAD
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
=======
This means emails are displayed in the terminal rather than being sent through an external email service.

The default sender address is:
>>>>>>> bdcd5a427dd9d9bbd9b59c5c6e8c477bf069d32c

```text
Authorization: Token YOUR_TOKEN_HERE
```

<<<<<<< HEAD
Use credentials from your own local development environment. Never publish passwords or authentication tokens.

## Running Tests

Run the automated test suite using:
=======
---

# Technologies Used

* Python

* Django

* Django REST Framework

* MariaDB/MySQL

* HTML

* CSS

* Bootstrap

* Requests

* Git

* GitHub

---

# Version Control
>>>>>>> bdcd5a427dd9d9bbd9b59c5c6e8c477bf069d32c

```bash
python manage.py test
```

<<<<<<< HEAD
You can also run Django's system checks:

```bash
python manage.py check
```

Review test output and error messages to identify any configuration problems or failing tests.

## Docker

The project includes a Dockerfile to containerise the Django News Application using Python 3.9.

### Build the Docker Image

Run the following command from the project root directory:

```bash
docker build -t consolidation .
```

The Dockerfile installs the system dependencies required for database connectivity, installs the Python packages listed in `requirements.txt`, and copies the application into the container.

### Run the Container

Start the application using:

```bash
docker run -d \
    --name consolidation-test \
    -p 8000:8000 \
    consolidation
```

The application will be available at:

[http://127.0.0.1:8000/](http://127.0.0.1:8000/)

The container runs Django's development server on port `8000`, with automatic code reloading disabled.

### Database Configuration

The application uses MariaDB/MySQL. Ensure that the database server is running and accessible from the container, and that the Django database settings are configured correctly.

If the database runs on the host machine using Docker Desktop on macOS, the hostname `host.docker.internal` can commonly be used to reach it from the container, provided the database accepts the connection.

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
=======
The repository contains the Django source code, migrations, templates, static files, tests, and documentation.

Sensitive files such as virtual environments, local SQLite databases, environment files, Python cache files, and operating-system files are excluded using `.gitignore`.
>>>>>>> bdcd5a427dd9d9bbd9b59c5c6e8c477bf069d32c
