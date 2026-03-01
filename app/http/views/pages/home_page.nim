import basolato/view

proc homePage*(baseUrl = "http://localhost:8080", siteName = "Todo App Template"): Component =
  let ogImageUrl = baseUrl & "/ogp.png"
  tmpli"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>$(siteName)</title>
        <meta name="description" content="Reusable Basolato + Nim Todo app starter template for Cloud Run.">
        <link rel="icon" href="/images/favicon.png" type="image/png">
        <meta property="og:title" content="$(siteName)">
        <meta property="og:description" content="Reusable Basolato + Nim Todo app starter template for Cloud Run.">
        <meta property="og:type" content="website">
        <meta property="og:url" content="$(baseUrl)/">
        <meta property="og:image" content="$(ogImageUrl)">
        <meta property="og:image:secure_url" content="$(ogImageUrl)">
        <meta property="og:image:type" content="image/png">
        <meta property="og:image:width" content="500">
        <meta property="og:image:height" content="500">
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="$(siteName)">
        <meta name="twitter:description" content="Reusable Basolato + Nim Todo app starter template for Cloud Run.">
        <meta name="twitter:image" content="$(ogImageUrl)">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;700;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/css/tailwind.css">
      </head>
      <body class="theme-grid min-h-screen bg-slate-950 text-slate-100">
        <header class="border-b border-cyan-300/20 bg-slate-950/85 backdrop-blur">
          <div class="mx-auto flex w-full max-w-6xl items-center justify-between px-6 py-4">
            <a href="/" class="inline-flex items-center gap-2 text-lg font-black tracking-wide text-cyan-300">
              <img src="/images/favicon.png" alt="Template icon" class="h-7 w-7">
              <span>$(siteName)</span>
            </a>
            <a href="https://github.com/itsumura-h/nim-basolato" class="rounded-lg border border-slate-600 px-3 py-2 text-xs font-semibold uppercase tracking-wide text-slate-200 hover:border-cyan-300 hover:text-cyan-200">
              Basolato
            </a>
          </div>
        </header>

        <main class="mx-auto grid w-full max-w-6xl gap-6 px-6 pb-16 pt-10 lg:grid-cols-[minmax(0,2fr)_minmax(0,1fr)]">
          <section class="card">
            <div class="flex flex-col gap-2 border-b border-slate-800/90 pb-5">
              <p class="text-xs font-semibold uppercase tracking-[0.2em] text-cyan-200">Starter App</p>
              <h1 class="text-3xl font-black text-white md:text-4xl">Todo App</h1>
              <p class="text-sm leading-relaxed text-slate-300">
                This is a reusable default page for Basolato + Nim projects.
                Tasks are stored in your browser (localStorage) so you can start customizing immediately.
              </p>
            </div>

            <form id="todo-form" class="mt-6 flex flex-col gap-3 sm:flex-row">
              <input
                id="todo-input"
                type="text"
                autocomplete="off"
                placeholder="Add a task..."
                class="todo-input"
              >
              <button type="submit" class="todo-btn-primary">Add Task</button>
            </form>

            <div class="mt-6 flex flex-wrap items-center gap-3 text-xs">
              <span class="rounded-full border border-slate-700 bg-slate-900/80 px-3 py-1 text-slate-300">
                Total: <strong id="total-count" class="text-slate-100">0</strong>
              </span>
              <span class="rounded-full border border-slate-700 bg-slate-900/80 px-3 py-1 text-slate-300">
                Active: <strong id="active-count" class="text-slate-100">0</strong>
              </span>
              <span class="rounded-full border border-slate-700 bg-slate-900/80 px-3 py-1 text-slate-300">
                Completed: <strong id="completed-count" class="text-slate-100">0</strong>
              </span>
            </div>

            <div class="mt-5 flex flex-wrap gap-2">
              <button type="button" class="todo-filter-btn todo-filter-btn-active" data-filter="all">All</button>
              <button type="button" class="todo-filter-btn" data-filter="active">Active</button>
              <button type="button" class="todo-filter-btn" data-filter="completed">Completed</button>
            </div>

            <ul id="todo-list" class="mt-4 space-y-2"></ul>
            <p id="empty-state" class="mt-4 rounded-xl border border-dashed border-slate-700 bg-slate-900/70 p-4 text-sm text-slate-400">
              No tasks yet. Add your first task.
            </p>

            <div class="mt-5 flex flex-wrap gap-3">
              <button id="clear-completed" type="button" class="rounded-lg border border-rose-500/50 px-3 py-2 text-xs font-semibold uppercase tracking-wide text-rose-300 hover:border-rose-400 hover:text-rose-200">
                Clear Completed
              </button>
            </div>
          </section>

          <aside class="card">
            <h2 class="text-lg font-bold text-cyan-200">Quick Start</h2>
            <ol class="mt-4 space-y-3 text-sm text-slate-200">
              <li class="rounded-lg border border-slate-700/80 bg-slate-900/70 p-3">
                1. `cp .env.example .env`
              </li>
              <li class="rounded-lg border border-slate-700/80 bg-slate-900/70 p-3">
                2. `./scripts/build.sh`
              </li>
              <li class="rounded-lg border border-slate-700/80 bg-slate-900/70 p-3">
                3. `./main`
              </li>
            </ol>

            <h3 class="mt-6 text-sm font-bold uppercase tracking-wide text-cyan-200">Customize</h3>
            <ul class="mt-3 space-y-2 text-sm text-slate-300">
              <li>Route: `main.nim`</li>
              <li>Controller: `app/http/controllers/home_controller.nim`</li>
              <li>View: `app/http/views/pages/home_page.nim`</li>
              <li>Styles: `src/styles/tailwind.css`</li>
            </ul>

            <h3 class="mt-6 text-sm font-bold uppercase tracking-wide text-cyan-200">Deploy</h3>
            <p class="mt-2 text-sm text-slate-300">
              Configure `.env`, then run:
            </p>
            <pre class="mt-2 rounded-lg border border-slate-700 bg-slate-950 p-3 text-xs text-slate-200">sh deploy.sh</pre>
          </aside>
        </main>

        <script>
          (function () {
            var storageKey = "todo_template_items_v1";
            var form = document.getElementById("todo-form");
            var input = document.getElementById("todo-input");
            var list = document.getElementById("todo-list");
            var emptyState = document.getElementById("empty-state");
            var clearCompleted = document.getElementById("clear-completed");
            var totalCount = document.getElementById("total-count");
            var activeCount = document.getElementById("active-count");
            var completedCount = document.getElementById("completed-count");
            var filterButtons = Array.prototype.slice.call(document.querySelectorAll("[data-filter]"));

            var todos = loadTodos();
            var currentFilter = "all";

            function loadTodos() {
              try {
                var raw = window.localStorage.getItem(storageKey);
                var parsed = raw ? JSON.parse(raw) : [];
                return Array.isArray(parsed) ? parsed : [];
              } catch (error) {
                return [];
              }
            }

            function saveTodos() {
              window.localStorage.setItem(storageKey, JSON.stringify(todos));
            }

            function escapeHtml(text) {
              return String(text)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
            }

            function filteredTodos() {
              if (currentFilter === "active") {
                return todos.filter(function (todo) { return !todo.completed; });
              }
              if (currentFilter === "completed") {
                return todos.filter(function (todo) { return todo.completed; });
              }
              return todos;
            }

            function todoRow(todo) {
              var doneClass = todo.completed ? "line-through text-slate-400" : "text-slate-100";
              var checked = todo.completed ? "checked" : "";
              return (
                '<li class="rounded-xl border border-slate-700/80 bg-slate-900/70 p-3">' +
                  '<div class="flex items-start gap-3">' +
                    '<input type="checkbox" class="mt-1 h-4 w-4 cursor-pointer accent-cyan-400" data-action="toggle" data-id="' + todo.id + '" ' + checked + '>' +
                    '<p class="min-w-0 flex-1 break-words text-sm ' + doneClass + '">' + escapeHtml(todo.text) + '</p>' +
                    '<button type="button" class="rounded-md border border-slate-700 px-2 py-1 text-[11px] font-semibold uppercase tracking-wide text-slate-300 hover:border-rose-400 hover:text-rose-300" data-action="delete" data-id="' + todo.id + '">Delete</button>' +
                  "</div>" +
                "</li>"
              );
            }

            function updateStats() {
              var total = todos.length;
              var completed = todos.filter(function (todo) { return todo.completed; }).length;
              var active = total - completed;
              totalCount.textContent = String(total);
              activeCount.textContent = String(active);
              completedCount.textContent = String(completed);
            }

            function updateFilterButtons() {
              filterButtons.forEach(function (button) {
                var isActive = button.getAttribute("data-filter") === currentFilter;
                button.classList.toggle("todo-filter-btn-active", isActive);
              });
            }

            function render() {
              var items = filteredTodos();
              list.innerHTML = items.map(todoRow).join("");
              emptyState.style.display = items.length === 0 ? "block" : "none";
              updateStats();
              updateFilterButtons();
            }

            form.addEventListener("submit", function (event) {
              event.preventDefault();
              var text = input.value.trim();
              if (!text) {
                return;
              }

              todos.unshift({
                id: Date.now().toString(36) + Math.random().toString(36).slice(2, 8),
                text: text,
                completed: false
              });
              saveTodos();
              input.value = "";
              render();
              input.focus();
            });

            list.addEventListener("click", function (event) {
              var target = event.target;
              if (!(target instanceof HTMLElement)) {
                return;
              }

              var action = target.getAttribute("data-action");
              var id = target.getAttribute("data-id");
              if (!action || !id) {
                return;
              }

              if (action === "toggle") {
                todos = todos.map(function (todo) {
                  if (todo.id !== id) {
                    return todo;
                  }
                  return {
                    id: todo.id,
                    text: todo.text,
                    completed: !todo.completed
                  };
                });
              }

              if (action === "delete") {
                todos = todos.filter(function (todo) { return todo.id !== id; });
              }

              saveTodos();
              render();
            });

            filterButtons.forEach(function (button) {
              button.addEventListener("click", function () {
                currentFilter = button.getAttribute("data-filter") || "all";
                render();
              });
            });

            clearCompleted.addEventListener("click", function () {
              todos = todos.filter(function (todo) { return !todo.completed; });
              saveTodos();
              render();
            });

            render();
          })();
        </script>

        <footer class="border-t border-slate-800 bg-slate-950/90">
          <div class="mx-auto flex w-full max-w-6xl flex-col gap-2 px-6 py-6 text-sm text-slate-400 md:flex-row md:items-center md:justify-between">
            <p>$(siteName)</p>
            <p>Todo starter powered by Basolato + Nim</p>
          </div>
        </footer>
      </body>
    </html>
  """
