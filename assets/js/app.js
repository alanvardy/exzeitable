// We need to import the CSS so that webpack will load it via MiniCssExtractPlugin.
import css from "../css/app.scss"
import "phoenix_html"

// import a from "./bootstrap_form.js"

import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live", Socket)
liveSocket.connect()
