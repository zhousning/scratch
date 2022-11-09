function day_pdt_modal() {
  $("#water-item-table").on('click', 'button', function(e) {
    $('#newModal').modal();
    var that = e.target
    var data_fct = that.dataset['fct'];
    var data_rpt = that.dataset['rpt'];
    var url = "/factories/" + data_fct + "/day_pdt_rpts/" + data_rpt + "/produce_report";
    $.get(url).done(function (data) {
      myChart.hideLoading();

      var flow = data.flow;
      var fct_id = data.fct_id;
      var day_rpt_id = data.day_rpt_id;
      
      var xls_download = "/factories/" + fct_id + "/day_pdt_rpts/" + day_rpt_id + "/xls_day_download";
      $("#xls-download").attr("href", xls_download);

      var day_flow_ctn = ''; 
      $.each(flow, function(k, v) {
        day_flow_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#day-flow-ctn").html(day_flow_ctn);

    });
  });

}
