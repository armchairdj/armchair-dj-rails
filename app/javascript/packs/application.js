/* Modernizr. */

import modernizr from 'modernizr';

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

/* jQuery plugins. */

require("monkey_patches/selectize");
// require("selectize-plugin-clear");

/* Turbolinks */

const Turbolinks = require("turbolinks");

Turbolinks.start();

/* UJS */

const Rails = require("rails-ujs");

Rails.start();

/* Stimulus */

import { Application            } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const context     = require.context("controllers", true, /\.js$/);

application.load(definitionsFromContext(context));
