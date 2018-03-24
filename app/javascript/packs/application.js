import $          from "jquery";
import _          from "underscore";

import { Application            } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const Rails      = require("rails-ujs")
const Turbolinks = require("turbolinks")

const application = Application.start();
const context     = require.context("./controllers", true, /\.js$/);

Rails.start();
Turbolinks.start()

application.load(definitionsFromContext(context));
