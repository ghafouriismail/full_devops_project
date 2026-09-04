# DevOps Project

A 3-tier task manager application used as the workload for this DevOps pipeline.

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Tier 1 — Frontend                │
│  src/frontend/                                      │
│  Vanilla HTML / CSS / JavaScript                    │
│  Served statically (any HTTP server / Nginx)        │
│  Communicates with the backend via REST (fetch API) │
└───────────────────────┬─────────────────────────────┘
                        │ HTTP  (JSON over REST)
                        ▼
┌─────────────────────────────────────────────────────┐
│                    Tier 2 — Backend                 │
│  src/backend/app.py                                 │
│  Python · Flask · Flask-SQLAlchemy                  │
│  REST API:  GET / POST / PUT / DELETE  /api/tasks   │
│  Runs on port 5000                                  │
└───────────────────────┬─────────────────────────────┘
                        │ SQLAlchemy ORM
                        ▼
┌─────────────────────────────────────────────────────┐
│                   Tier 3 — Database                 │
│  SQLite  (file: src/backend/instance/tasks.db)      │
│  Single table: tasks (id, title, done)              │
└─────────────────────────────────────────────────────┘
```

### Data flow

1. The browser loads `index.html` and `app.js` from the frontend tier.
2. On load (and after every mutation), `app.js` calls `GET /api/tasks` to fetch the task list.
3. User actions (add / toggle / delete) trigger `POST`, `PUT`, or `DELETE` requests to the Flask backend.
4. Flask validates the request, updates the SQLite database via SQLAlchemy, and returns JSON.
5. The frontend re-renders the list from the fresh response.

---

## Running locally

### Backend

```bash
cd src/backend
pip install -r requirements.txt
python app.py          # starts on http://localhost:5000
```

### Frontend

Open `src/frontend/index.html` directly in a browser, or serve it with any static server:

```bash
cd src/frontend
python -m http.server 8080   # http://localhost:8080
```

---

## Source layout

```
src/
├── backend/
│   ├── app.py           # Flask app + route handlers
│   ├── models.py        # SQLAlchemy Task model
│   └── requirements.txt
└── frontend/
    ├── index.html       # Single-page UI
    ├── style.css
    └── app.js           # fetch-based API client
```
