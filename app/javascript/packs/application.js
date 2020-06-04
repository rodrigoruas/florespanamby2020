/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import "jquery"
import "./pagarme"
import 'mapbox-gl/dist/mapbox-gl.css'

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

$(document).ready(function(){
  $("input[name=cep]").blur(function(){
    var cep = $(this).val().replace(/[^0-9]/, '');
    // console.log(cep)
    if(cep){
      var url = `https://viacep.com.br/ws/${cep}/json/`
      // console.log(url)
      $.ajax({
                    url: url,
                    dataType: 'jsonp',
                    crossDomain: true,
                    contentType: "application/json",
          success : function(json){
            if(json.logradouro){
              $("input[name=rua]").val(json.logradouro);
              $("input[name=bairro]").val(json.bairro);
              $("input[name=cidade]").val(json.localidade);
              $("input[name=uf]").val(json.uf);
              // console.log(json)
            }
          }
      });
    }
  });
});
