import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import $ from 'jquery';
window.$ = window.jQuery = $;

import Chart from 'chart.js/auto';
window.Chart = Chart;

import Raty from "../raty";
window.raty = function(elem,opt) {
  let raty = new Raty(elem, opt);
  raty.init();
  return raty;
}
window.Raty = Raty;

import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 

Rails.start()
Turbolinks.start()
ActiveStorage.start()
