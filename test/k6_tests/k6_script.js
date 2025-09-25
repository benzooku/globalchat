import http from "k6/http";
import ws from "k6/ws";

export const options = {
  // Key configurations for spike in this section
  stages: [
    { duration: "2m", target: 1 }, // fast ramp-up to a high point
    // No plateau
    { duration: "1m", target: 0 }, // quick ramp-down to 0 users
  ],
};

const host = "localhost:4000";

export default function () {
  // Step 1: GET request to retrieve CSRF token
  const res = http.get(`http://${host}/`);
  const html = res.html();
  const csrfToken = html.find('meta[name="csrf-token"]').attr("content");
  const phxMain = html.find("[data-phx-main]");
  const phxId = phxMain.attr("id");
  const phxSession = phxMain.attr("data-phx-session");
  const phxStatic = phxMain.attr("data-phx-static");

  // Step 2: Establish WebSocket connection
  const url = `wss://${host}/live/websocket?_csrf_token=${csrfToken}&vsn=2.0.0`;

  ws.connect(url, {}, function (socket) {
    socket.on("open", function open() {
      console.log("open");
      // Join the LiveView
      socket.send(
        JSON.stringify([
          "4",
          "4",
          `lv:${phxId}`,
          "phx_join",
          {
            url: `http://${host}/`,
            params: { _csrf_token: csrfToken, _mounts: 0, _mount_attempts: 0 },
            session: phxSession,
            static: phxStatic,
          },
        ]),
      );
    });

    socket.on("message", function (message) {
      const [a, b, c, type, payload] = JSON.parse(message);
      if (
        a == "4" &&
        b == "4" &&
        type == "phx_reply" &&
        payload.status == "ok"
      ) {
        console.log("send");

        socket.send(
          JSON.stringify([
            "4",
            "26",
            `lv:${phxId}`,
            "event",
            {
              type: "form",
              event: "send",
              value: "content=9999999999",
            },
          ]),
        );
      }
    });

    socket.setTimeout(function () {
      socket.close();
    }, 120_000);
  });
}
