import Selectize from "selectize";

window.Selectize = Selectize;

_.extend(Selectize.prototype, {
  getOptionByText: function(text) {
    return this.getElementWithText(text, this.$dropdown_content.find('[data-selectable]'));
  },

  getElementWithText: function(text, $els) {
    var $el;

    if (typeof text !== 'undefined' && text !== null) {
      for (var i = 0, n = $els.length; i < n; i++) {
        $el = $els.eq(i);

        if ($el.text() === text) {
          return $el;
        }
      }
    }

    return $();
  },

  getText: function () {
    return this.getItem(this.getValue()).text();
  },

  setText: function (text) {
    var selectize = this;

    $.each(this.options, function (propertyName, propertyValue) {
      if (propertyValue[selectize.settings.labelField] === text) {
        selectize.setValue(propertyName);

        return false;
      }
    });
  },

  findOrCreateByText: function (text) {
    this.refreshOptions(false);

    const $existing = this.getOptionByText(text);

    if ($existing[0]) {
      this.setText(text);
    } else {
      this.createItem(text, true);
    }
  }
});
