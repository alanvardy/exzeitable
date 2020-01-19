// We need to import the CSS so that webpack will load it via MiniCssExtractPlugin.
import css from "../css/app.scss"
import $ from "jquery"

window.jQuery = $
window.$ = $

import "bootstrap"
import "phoenix_html"

import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } });
liveSocket.connect()
