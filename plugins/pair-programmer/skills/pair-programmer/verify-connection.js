const path = require("path");
const dotenv = require("dotenv");

const cwdArg = process.argv.find(a => a.startsWith("--cwd="));
const userCwd = cwdArg ? cwdArg.split("=")[1] : null;
if (userCwd) {
  dotenv.config({ path: path.join(userCwd, ".env") });
}

const { connect } = require("videodb");

const apiKey = process.env.VIDEO_DB_API_KEY;
if (!apiKey) {
  console.error("VIDEO_DB_API_KEY not set");
  process.exit(1);
}

(async () => {
  try {
    const conn = connect({ apiKey });
    const coll = await conn.getCollection();
    console.log("Connected to VideoDB, collection:", coll.id);
  } catch (err) {
    console.error("Connection failed:", err.message);
    process.exit(2);
  }
})();
