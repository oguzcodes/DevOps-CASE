import express from "express";
const router = express.Router();

router.get("/", async (req, res) => {
  const status = {
    uptime: process.uptime(),
    message: "OK",
    timestamp: Date.now(),
  };
  res.send(status).status(200);
});

export default router;
