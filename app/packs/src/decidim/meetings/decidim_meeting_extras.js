$(() => {

  date_radio_filter = $(".date_collection_radio_buttons_filter");

  if (date_radio_filter.length > 0 ){
    $('input[type=radio][name="filter[date]"]').change(function(){
      $(".meeting_report_collection_radio_buttons_filter").toggle(this.value == "past");
      if ($(".meeting_report_collection_radio_buttons_filter").is(":hidden")) {
        $('input[type=radio][name="filter[meeting_report]"][value=all]').prop('checked', true);
      }
    });
    $(".meeting_report_collection_radio_buttons_filter").toggle($('input[type=radio][name="filter[date]"][value=past]').prop("checked"));
  }

  date_check_filter = $(".date_check_boxes_tree_filter");
  if (date_check_filter.length > 0) {
    $('input[type=checkbox][name="filter[date][]"][value=past]').change(function(){
      console.log(this.value == "past" && this.checked == true);
      $(".meeting_report_collection_radio_buttons_filter").toggle(this.value == "past" && this.checked == true);
      if ($(".meeting_report_collection_radio_buttons_filter").is(":hidden")) {
        $('input[type=radio][name="filter[meeting_report]"][value=all]').prop('checked', true);
      }
    });
    $(".meeting_report_collection_radio_buttons_filter").toggle($('input[type=checkbox][name="filter[date][]"][value=past]').prop("checked"));
  }
});
