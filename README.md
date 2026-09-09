# django-vite-starter

A production-ready starter template for **Django + Vite + Tailwind CSS**.

## Stack

- **[Django](https://www.djangoproject.com/)** — Python web framework
- **[Vite](https://vite.dev/)** — frontend build tool with HMR
- **[Tailwind CSS v4](https://tailwindcss.com/)** — utility-first CSS
- **[django-vite](https://github.com/MrBin99/django-vite)** — Django + Vite integration
- **[uv](https://docs.astral.sh/uv/)** — Python package manager
- **[WhiteNoise](https://whitenoise.readthedocs.io/)** — static file serving
- **[Gunicorn](https://gunicorn.org/)** — WSGI server

## Quick start

```bash
# 1. Install Python dependencies
uv sync

# 2. Install Node dependencies
npm install

# 3. Configure environment
cp .env.example .env
# Edit .env and set SECRET_KEY (see below to generate one)

# 4. Start both servers
./scripts/dev.sh
```

Visit **[http://localhost:8000](http://localhost:8000)**

## Generate a secret key

```bash
python -c "import secrets; print(secrets.token_urlsafe(50))"
```



## Project structure

```bash
  django-vite-starter/
  ├── myproject/          # Django settings package
  │   ├── settings.py
  │   ├── urls.py
  │   ├── wsgi.py
  │   └── asgi.py
  ├── core/               # Main Django app
  │   ├── views.py
  │   ├── urls.py
  │   └── forms.py
  ├── frontend/           # Frontend source files
  │   ├── index.ts        # Main TypeScript entry point
  │   ├── style.css       # Tailwind CSS + custom theme
  │   ├── ga.js           # Google Analytics (optional)
  │   └── public/         # Static assets copied to /static/ by Vite
  ├── templates/          # Django HTML templates
  ├── static/             # Vite build output (gitignored)
  └── scripts/
      └── dev.sh          # Start Django + Vite concurrently
```



## Environment variables


| Variable                  | Default                            | Description                                  |
| ------------------------- | ---------------------------------- | -------------------------------------------- |
| `SECRET_KEY`              | —                                  | Django secret key (required)                 |
| `DEBUG`                   | `True`                             | Debug mode                                   |
| `ALLOWED_HOSTS`           | `localhost,127.0.0.1`              | Comma-separated allowed hosts                |
| `EMAIL_BACKEND`           | console                            | Django email backend class                   |
| `EMAIL_HOST`              | `smtp.gmail.com`                   | SMTP host                                    |
| `EMAIL_PORT`              | `587`                              | SMTP port                                    |
| `EMAIL_HOST_USER`         | —                                  | SMTP username                                |
| `EMAIL_HOST_PASSWORD`     | —                                  | SMTP password                                |
| `DEFAULT_FROM_EMAIL`      | `My Project <noreply@example.com>` | From address                                 |
| `CONTACT_RECIPIENT_EMAIL` | `hello@example.com`                | Contact form recipient                       |
| `CSRF_TRUSTED_ORIGINS`    | —                                  | Comma-separated trusted origins (production) |
| `DJANGO_VITE_DEV_MODE`    | `False`                            | Set `True` to enable Vite dev server HMR     |




## Contact form

The template includes a contact form (`/contact/`) with:

- Honeypot spam protection (hidden `tel` field)
- Email sending via Django's `EmailMessage`

**In development** emails print to the console (default `EMAIL_BACKEND`).  
**In production** set `EMAIL_HOST`, `EMAIL_HOST_USER`, `EMAIL_HOST_PASSWORD` for SMTP delivery.

## Google Analytics

1. Replace `YOUR_GA_ID` in `frontend/ga.js` with your measurement ID
2. Uncomment the GA script tag in `templates/base.html`



## Production build

```bash
# Build frontend assets
npm run build

# Collect static files
uv run manage.py collectstatic
```

Set `DJANGO_VITE_DEV_MODE=False` (or omit it) in production so Django serves the built assets via WhiteNoise.

## Docker

```bash
docker build -t myproject .
docker run --rm \
  -e SECRET_KEY=$SECRET_KEY \
  -e DEBUG=False \
  -e ALLOWED_HOSTS=localhost \
  -p 8000:8000 \
  myproject
```

Or with Docker Compose (development with file watching):

```bash
docker compose up
```

