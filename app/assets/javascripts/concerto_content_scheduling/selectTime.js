function initSelectTime() {
  $('.timefield').timepicker();
}

$(document).on('turbolinks:load', initSelectTime);
