import Rails      from "rails-ujs";
import Turbolinks from "turbolinks";
import $          from "jquery";
import _          from "underscore";

import { Application            } from "stimulus"
import { definitionsFromContext } from 'stimulus/webpack-helpers'
import { autoload               } from "stimulus/webpack-helpers"

const application = Application.start()
const context     = require.context("./controllers", true, /\.js$/)

application.load(definitionsFromContext(context))
