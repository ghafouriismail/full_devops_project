const API =
  window.location.port === "8080"
    ? "http://localhost:5000/api/tasks"
    : "/api/tasks";

async function fetchTasks() {
  const res = await fetch(API);
  const tasks = await res.json();
  renderTasks(tasks);
}

function renderTasks(tasks) {
  const list = document.getElementById("task-list");
  list.innerHTML = "";
  tasks.forEach((task) => {
    const li = document.createElement("li");

    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.checked = task.done;
    checkbox.addEventListener("change", () => toggleTask(task.id, checkbox.checked));

    const span = document.createElement("span");
    span.textContent = task.title;
    if (task.done) span.classList.add("done");

    const delBtn = document.createElement("button");
    delBtn.textContent = "Delete";
    delBtn.classList.add("btn-delete");
    delBtn.addEventListener("click", () => deleteTask(task.id));

    li.append(checkbox, span, delBtn);
    list.appendChild(li);
  });
}

async function createTask(title) {
  await fetch(API, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ title }),
  });
  fetchTasks();
}

async function toggleTask(id, done) {
  await fetch(`${API}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ done }),
  });
  fetchTasks();
}

async function deleteTask(id) {
  await fetch(`${API}/${id}`, { method: "DELETE" });
  fetchTasks();
}

document.getElementById("task-form").addEventListener("submit", (e) => {
  e.preventDefault();
  const input = document.getElementById("task-input");
  const title = input.value.trim();
  if (title) {
    createTask(title);
    input.value = "";
  }
});

fetchTasks();
