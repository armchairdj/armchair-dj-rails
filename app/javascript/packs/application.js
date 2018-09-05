/* Modernizr. */

import modernizr from "modernizr";

/* Underscore. */

import _ from "underscore";

window._ = _;

/* jQuery. */

import $ from "jquery";

window.$ = window.jQuery = $;

/* jQuery config. */

$(document).on("turbolinks:load", function () {
  $.ajaxSetup({
    headers:  { "X-CSRF-Token": $("meta[name='csrf-token']").attr("content") },
    dataType: "json"
  });
})

/* Selectize. */

const Selectize = require("../monkey_patches/selectize");

window.Selectize = Selectize;

/* Turbolinks */

const Turbolinks = require("turbolinks");

Turbolinks.start();

/* Unobtrusive JavaScript driver. */

const Rails = require("rails-ujs");

Rails.start();

/* Markdown Editor. */

const InscrybMDE = require("inscrybmde");

window.InscrybMDE = InscrybMDE;

/* Stimulus */

import { Application            } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const context     = require.context("controllers", true, /\.js$/);

application.load(definitionsFromContext(context));
