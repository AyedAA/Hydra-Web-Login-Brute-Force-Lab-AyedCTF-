#!/bin/bash

echo "======================================="
echo "     AyedCTF - Web Hydra Lab Setup"
echo "======================================="

# ------------------------------
# 1) CHECK IF NODE IS INSTALLED
# ------------------------------
echo "[+] Checking Node.js installation..."

if ! command -v node >/dev/null 2>&1; then
    echo "[!] Node.js not found. Installing Node.js..."
    sudo apt update
    sudo apt install -y nodejs npm

    # If the default Kali/Ubuntu version is old → install latest Node 20
    NODE_VERSION=$(node -v 2>/dev/null)
    if [[ "$NODE_VERSION" == "" ]]; then
        echo "[!] Default Node install failed or outdated. Installing latest Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt install -y nodejs
    fi
else
    echo "[+] Node.js already installed: $(node -v)"
fi

sleep 1

# ------------------------------
# 2) CREATE PROJECT STRUCTURE
# ------------------------------
echo "[+] Creating project directories..."
mkdir -p Hydra-Web-Login-Lab
cd Hydra-Web-Login-Lab
mkdir -p public
mkdir -p flags

# ------------------------------
# 3) CREATE package.json
# ------------------------------
echo "[+] Creating package.json..."
cat <<EOF > package.json
{
  "name": "hydra-web-lab",
  "version": "1.0.0",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2",
    "body-parser": "^1.20.2"
  }
}
EOF

# ------------------------------
# 4) CREATE server.js
# ------------------------------
echo "[+] Creating server.js..."
cat <<EOF > server.js
const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

const VALID_USER = "victim";
const VALID_PASS = "coffee123";

app.post('/login', (req, res) => {
    const { username, password } = req.body;

    if (username === VALID_USER && password === VALID_PASS) {
        const flag = fs.readFileSync(path.join(__dirname, "flags/user.txt"), "utf8");
        return res.send(\`<h2>Login Successful!</h2><p>Flag: \${flag}</p>\`);
    }

    return res.status(401).send("Invalid credentials");
});

app.listen(3000, () => {
    console.log("Hydra Web Lab running on http://localhost:3000/login.html");
});
EOF

# ------------------------------
# 5) CREATE login.html
# ------------------------------
echo "[+] Creating login.html..."
cat <<EOF > public/login.html
<!DOCTYPE html>
<html>
<head>
    <title>Web Login</title>
</head>
<body>
    <h2>Login Form</h2>
    <form method="POST" action="/login">
        <label>Username:</label>
        <input type="text" name="username"><br><br>

        <label>Password:</label>
        <input type="password" name="password"><br><br>

        <button type="submit">Login</button>
    </form>
</body>
</html>
EOF

# ------------------------------
# 6) FLAGS
# ------------------------------
echo "[+] Creating flags..."
echo "ayedCTF{web_login_success}" > flags/user.txt
echo "ayedCTF{admin_panel_flag}" > flags/admin.txt

# ------------------------------
# 7) INSTALL NPM DEPENDENCIES
# ------------------------------
echo "[+] Installing Node packages..."
npm install

# ------------------------------
# 8) HYDRA WORDLIST
# ------------------------------
echo "[+] Creating Hydra wordlist..."
cat <<EOF > pass.txt
admin
password
123456
toor
coffee123
111111
EOF

# ------------------------------
# 9) DONE
# ------------------------------
echo "======================================="
echo "     Web Hydra Lab Ready!"
echo "======================================="
echo "Run the lab with:"
echo "  cd Hydra-Web-Login-Lab"
echo "  node server.js"
echo ""
echo "Open the browser:"
echo "  http://localhost:3000/login.html"
echo ""
echo "Hydra command:"
echo "hydra -l victim -P pass.txt localhost http-post-form \"/login:username=^USER^&password=^PASS^:Invalid credentials\""
echo "======================================="
