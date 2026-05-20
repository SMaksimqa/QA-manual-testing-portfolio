# CLAUDE.md

Guidance for AI assistants (Claude Code) working in this repository.

## What this repository is

This is a **QA portfolio**, not a deployable application. It collects work
samples from a junior QA engineer (manual + automation): bug reports, test
cases, API test collections, UI autotests, SQL queries, small Python scripts,
and notes on QA tooling (Charles Proxy, browser DevTools, Linux CLI).

The primary "product" of this repo is **documentation read on GitHub**. Most
files are Markdown with embedded screenshots. The runnable code (Python,
Selenium, SQL, Postman) exists to demonstrate skills, not to be deployed or
imported as a library. There is no build system, no CI, no package manifest at
the root.

**Language:** content is written primarily in **Russian** (some English in the
Linux/tooling notes). Match the existing language of a file when editing it.
Keep section structure, emoji headers, and tone consistent with neighboring
files.

## Repository structure

```
.
├── README.md                     # Top-level portfolio overview (RU) + tech-stack badges
├── manual-testing/
│   ├── bug-reports/              # Real bugs found in mobile/web apps
│   │   ├── booking/              # Each target gets its own folder: <name>-web.md + screenshots/
│   │   ├── kamkombank/
│   │   └── ozon-web/
│   └── test-cases/               # Positive + negative test-case docs (login-flow.md, ozon-web.md)
├── automation/
│   └── selenium-herokuapp-login/ # Selenium + Pytest + Allure UI login tests
│       ├── tests/test_login.py
│       ├── requirements.txt
│       └── screenshots/          # Allure report screenshots
├── api-testing/
│   ├── JSONPlaceholder.final.postman_collection.json
│   └── screenshots/
├── python-examples/              # Standalone learning scripts (no shared package)
│   ├── calculator/
│   ├── create-files/
│   └── even-numbers/
├── sql/                          # Standalone .sql query files (SQL Academy schema)
└── tools/
    ├── charles/                  # Charles Proxy intercept/mock/throttling notes
    ├── devtools/                 # Browser DevTools notes
    └── linux/docs/               # Linux command cheatsheets for QA work
```

### Conventions for the directory layout

- **Every section folder has its own `README.md`** that indexes and explains
  its contents. When you add a new artifact, update the nearest `README.md`
  (and the root `README.md` if it's a new top-level section).
- **Screenshots live in a `screenshots/` subfolder** next to the doc that
  references them, linked with relative Markdown paths
  (`![alt](screenshots/foo.png)`). Empty screenshot folders are kept in git
  with a `.gitkeep` or placeholder `README.md`.
- Bug-report folders are named after the target product; the main report file
  is `<product>-web.md`.

## Running the code

### Selenium UI tests (`automation/selenium-herokuapp-login/`)

```bash
cd automation/selenium-herokuapp-login
pip install -r requirements.txt          # selenium, pytest, allure-pytest
pytest                                    # run tests (needs Chrome + chromedriver)
pytest --alluredir=allure-results         # collect Allure results
allure serve allure-results               # view the report (needs Allure CLI)
```

Notes:
- Tests drive a **real Chrome browser** against the live site
  `https://the-internet.herokuapp.com/login`, so they require Chrome +
  a matching chromedriver and **network access**. There is no headless config
  or `conftest.py`; the `browser` fixture instantiates `webdriver.Chrome()`
  directly in `test_login.py`.
- Allure annotations (`epic/feature/story`, `severity`, `tag`, `allure.step`)
  are part of the demonstration — preserve them when editing tests.
- The folder's `README.md` contains two known typos: `requiremets.txt` (should
  be `requirements.txt`) and `pytest –alluredir=...` (uses an en-dash `–`
  instead of `--`). Don't copy these into commands; fix them only if asked.

### Python examples (`python-examples/`)

Each script is standalone and run directly. They are interactive
(`input()`-driven) and use only the standard library:

```bash
python python-examples/calculator/calculator.py
```

There is no test suite, linter config, or shared module for these.

### SQL (`sql/`)

`.sql` files are written against the **SQL Academy** schema
(`Teacher`, `Student`, `Subject`, `Schedule`, ...). They are not run against a
local database in this repo — they're reference queries with result
screenshots. Keep the leading `-- filename.sql` + `-- description` comment
header convention when adding new queries.

### API testing (`api-testing/`)

A Postman collection (`JSONPlaceholder.final.postman_collection.json`) for the
JSONPlaceholder demo API. Import it into Postman and run via the Collection
Runner; it is not executed in this repo.

## Conventions to follow

- **Documentation-first:** the most common change is editing Markdown. Keep the
  existing heading style, emoji usage, and bilingual conventions of the file
  you're touching.
- **Don't invent a build/test toolchain.** There is no root `package.json`,
  `Makefile`, `pyproject.toml`, or CI workflow. Don't add one unless explicitly
  requested.
- **Keep code samples simple and readable.** The Python/SQL examples are
  deliberately beginner-level teaching artifacts; don't "improve" them with
  abstractions, type systems, or frameworks unless asked.
- **Relative links and image paths** are how sections cross-reference each
  other. Verify a screenshot file exists before linking it.
- **Personal contact details** appear in `README.md` (Telegram/email). Don't
  alter or add personal data unless requested.

## Git workflow

- Active development branch for this work: `claude/add-claude-documentation-wUlTY`.
- Push with `git push -u origin <branch-name>`. Do **not** push to `main` or
  open a pull request unless the user explicitly asks.
- Commit message style in history is short and imperative, frequently tied to
  the file touched (e.g. `Update README.md`, `Create README.md`,
  `refactor linux section`). Keep messages concise and descriptive.
