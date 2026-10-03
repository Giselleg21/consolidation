# Django News Application

## Overview

This project is a Django capstone application demonstrating user authentication, role-based access control, article and newsletter management, subscriptions, editor approval, email notifications, and a RESTful API.

The application uses **MariaDB/MySQL** as its database.

The project has been prepared as a consolidation project and includes:

* Git version control
* A `requirements.txt` file
* Sphinx documentation
* A Dockerfile
* A `.dockerignore` file
* Project documentation
* Automated tests

## Features

### User Authentication

Users can:

* Register for an account.
* Log in and log out.
* Select a role during registration.
* Be automatically assigned to the appropriate Django group.
* Access functionality based on their assigned role.

The application uses a custom `CustomUser` model based on Django's `AbstractUser`.

### Role-Based Permissions

The application uses Django groups and permissions for different user roles.

#### Reader

Readers can:

* View approved articles.
* View newsletters.
* Subscribe to publishers.
* Subscribe to journalists.
* View articles from their subscriptions.

Readers cannot create, edit, delete, or approve articles.

#### Journalist

Journalists can:

* Create articles.
* View articles.
* Update articles.
* Delete articles.
* Create newsletters.
* Update newsletters.
* Delete newsletters.
* Add articles to newsletters.
* Remove articles from newsletters.

New articles created by journalists require editor approval before being publicly available.

#### Editor

Editors can:

* View articles awaiting approval.
* Approve articles.
* Update articles.
* Delete articles.
* Manage newsletters.

Editors are responsible for reviewing articles before they become approved.

#### Publisher

Publishers can:

* Create a publication.
* Update their publication.
* Delete their publication.
* Manage journalists assigned to their publication.
* Manage editors assigned to their publication.
* View articles associated with their publication.
* View newsletters created by journalists assigned to their publication.

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

## Article Approval

The application includes an editor-only article review system.

When an article is approved:

1. The article's approval status is changed to `True`.
2. Relevant subscribers are identified.
3. Email notifications are generated.
4. A POST request is made to the application's `/api/approved/` endpoint.

During development, the email system uses Django's console email backend.

## Newsletters

Newsletters contain:

* Title
* Description
* Creation date
* Author
* Associated articles

Journalists can create and manage newsletters.

Multiple articles can be associated with a newsletter. Removing an article from a newsletter does not delete the article itself.

## Subscriptions

Readers can subscribe to:

* Publishers
* Individual journalists

The application uses Django `ManyToManyField` relationships to manage subscriptions.

The subscribed articles API filters approved articles according to the reader's subscriptions.

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

## Signals

Django signals are used for automatic application behaviour.

The application includes signals for:

* Automatically assigning users to their role-based group when they register.
* Detecting when an article changes from unapproved to approved.
* Sending email notifications after an article is approved.
* Sending approval information to the application's API endpoint.

The signals are loaded through the `NewsConfig.ready()` method.

## Database Models

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

# Installation and Setup

The following instructions explain how to install and run the project from a fresh computer.

The local development instructions assume macOS and MariaDB/MySQL.

## 1. Clone the Repository

Clone the consolidation repository:

```bash
git clone https://github.com/Giselleg21/consolidation.git
```

Enter the project directory:

```bash
cd consolidation
```

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

The virtual environment is intentionally excluded from Git using `.gitignore`. Each computer should create its own virtual environment rather than committing the existing `myenv` directory.

## 3. Install the Required Python Packages

The project includes a `requirements.txt` file containing the required Python packages and versions.

Install the dependencies with:

```bash
pip install -r requirements.txt
```

## 4. Install MariaDB

If MariaDB is not already installed, it can be installed using Homebrew:

```bash
brew install mariadb
```

The `pkg-config` package may also be required when installing `mysqlclient`:

```bash
brew install pkg-config
```

Check the MariaDB installation:

```bash
mariadb --version
```

Check whether the MariaDB server is running:

```bash
mariadb-admin ping
```

If MariaDB is not running, start it with:

```bash
brew services start mariadb
```

## 5. Create the Database

Create a database and a local database user using credentials chosen by the person setting up the project.

For example, from the MariaDB command line:

```sql
CREATE DATABASE your_database_name;
CREATE USER 'your_database_user'@'localhost' IDENTIFIED BY 'your_database_password';
GRANT ALL PRIVILEGES ON your_database_name.* TO 'your_database_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

**Do not use these example values as real passwords or commit real database credentials to Git.**

## 6. Configure Database Credentials

Open:

```text
News_application/settings.py
```

Configure the Django database settings with the database name, username, password, host, and port created on the computer.

For local development, the database configuration should use the computer's MariaDB server.

For a production deployment, credentials should be supplied securely through environment variables or another secrets-management system rather than being committed to source control.

The repository does not contain personal or production database credentials.

## 7. Apply Database Migrations

With the virtual environment activated, run:

```bash
python manage.py migrate
```

## 8. Create the Application Groups

Run:

```bash
python manage.py create_groups
```

This creates the required:

* Reader group
* Journalist group
* Editor group
* Publisher group

## 9. Create an Administrator Account

Create a Django superuser:

```bash
python manage.py createsuperuser
```

Follow the prompts to enter the administrator username, email address, and password.

## 10. Check the Project

Run Django's system check:

```bash
python manage.py check
```

The expected result is similar to:

```text
System check identified no issues (0 silenced).
```

## 11. Run the Tests

Run the automated tests:

```bash
python manage.py test
```

The tests should complete successfully before using the application.

## 12. Start the Development Server

Start Django's development server:

```bash
python manage.py runserver
```

The application will normally be available at:

```text
http://127.0.0.1:8000/
```

# Docker

The project includes a Dockerfile so that the Django application can be built and run in a container.

The Docker image installs the Python dependencies from `requirements.txt`, copies the Django project into the image, and exposes port `8000`.

## 1. Build the Docker Image

From the project root, run:

```bash
docker build -t consolidation .
```

## 2. Run the Docker Container

The Django application requires access to a MariaDB/MySQL database.

When using Docker Desktop on macOS, a database running on the host computer can be accessed using `host.docker.internal`.

Run the container with:

```bash
docker run -d \
  --name consolidation-test \
  -p 8000:8000 \
  -e DB_HOST=host.docker.internal \
  consolidation
```

The application can then be accessed at:

```text
http://localhost:8000/
```

Check that the container is running with:

```bash
docker ps
```

To view the application logs:

```bash
docker logs consolidation-test
```

To stop and remove the container:

```bash
docker stop consolidation-test
docker rm consolidation-test
```

### Docker Database Configuration

The Docker container does not include a MariaDB server. A MariaDB/MySQL database must therefore be available separately.

The database credentials must be configured for the environment where the application is being run. Real passwords and other secrets should not be placed in the Dockerfile, README, or Git repository.

## Sphinx Documentation

Sphinx documentation is included in the `docs` directory.

The documentation source includes API documentation generated from the Django project.

To build the HTML documentation, run:

```bash
cd docs
make html
```

The generated HTML documentation is stored in:

```text
docs/_build/html/
```

The generated `_build` directory is excluded from Git.

## Main Application URLs

| URL                       | Purpose                        |
| ------------------------- | ------------------------------ |
| `/`                       | Home page                      |
| `/register/`              | Register a new user            |
| `/login/`                 | Log into an existing account   |
| `/articles/`              | View articles                  |
| `/articles/create/`       | Create an article              |
| `/newsletters/`           | View newsletters               |
| `/newsletters/create/`    | Create a newsletter            |
| `/editor/articles/`       | Editor article review page     |
| `/publisher/create/`      | Create a publication           |
| `/publisher/journalists/` | Manage publication journalists |
| `/publisher/editors/`     | Manage publication editors     |
| `/publisher/view/`        | View a publication             |
| `/publisher/update/`      | Update a publication           |
| `/publisher/delete/`      | Delete a publication           |
| `/admin/`                 | Django administration site     |

## Project Structure

The main project structure is:

```text
consolidation/
│
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
│
├── News_application/
│   ├── settings.py
│   ├── urls.py
│   ├── asgi.py
│   └── wsgi.py
│
├── docs/
│   ├── conf.py
│   ├── index.rst
│   └── ...
│
├── manage.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md
```

## Email Notifications

During development, the application uses Django's console email backend:

```python
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
```

This means email messages are displayed in the terminal rather than being sent through an external email service.

The development sender address is:

```text
news@example.com
```

## Technologies Used

* Python
* Django
* Django REST Framework
* MariaDB/MySQL
* HTML
* CSS
* Bootstrap
* Requests
* Sphinx
* Git
* GitHub
* Docker

## Version Control

The project is maintained using Git and hosted on GitHub.

The repository contains the Django source code, migrations, templates, static files, tests, Docker configuration, and Sphinx documentation.

The project uses separate Git branches for the documented and containerised development work. These branches have been merged into the final `main` branch.

Sensitive and unnecessary local files such as virtual environments, local databases, Python cache files, Sphinx build output, and operating-system files are excluded using `.gitignore`.

## Public Repository

The public GitHub repository for this consolidation project is:

https://github.com/Giselleg21/consolidation
