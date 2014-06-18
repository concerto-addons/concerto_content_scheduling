function initSelectTime() {
  $('.timefield').timepicker();
}

$(document).ready(initSelectTime);
$(document).on('page:change', initSelectTime);