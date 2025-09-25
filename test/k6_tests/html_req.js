import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: 500,         // number of concurrent virtual users
  duration: "60s",  // total test time
};

export default function () {
  http.get("http://localhost:4000/");
  sleep(4);
}

