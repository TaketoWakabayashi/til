import { Manifest } from "deno-slack-sdk/mod.ts";
import ChatGPTWorkflow from "./workflows/chatgpt_workflow.ts";

export default Manifest({
  name: "ChatGPT",
  description: "chat bot answers any questions with official ChatGPT API",
  icon: "assets/icon.png",
  workflows: [
    ChatGPTWorkflow,
  ],
  outgoingDomains: [
    "api.openai.com",
  ],
  botScopes: [
    "commands",
    "app_mentions:read",
    "chat:write",
    "chat:write.public",
    "channels:read",
  ],
});