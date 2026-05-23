const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <h1>Hello, World!</h1>
    <h2>Version 2 deployed automatically via GitHub Actions on code push!</h2>
  `);
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});