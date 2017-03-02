var ConcertoContentScheduling = {
  _initialized: false,

  initSelectTime: function () {
    $('.timefield').timepicker();
  },

  initHandlers: function () {
    if (!ConcertoContentScheduling._initialized) {
      ConcertoContentScheduling.initSelectTime();
      ConcertoContentScheduling._initialized = true;
    }
  }
}

$(document).ready(ConcertoContentScheduling.initHandlers);
$(document).on('turbolinks:load', ConcertoContentScheduling.initHandlers);
