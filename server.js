const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

app.get(["/"], (req, res) => {
  res.send("Hello from Express");
});

app.listen(port, () => console.log(`HelloNode app listening on port ${port}!`));
