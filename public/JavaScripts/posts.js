$(function() {
  $(".toggle").on("click", function() {
    $(".toggle").toggleClass("checked");
    if(!$('input[name="check"]').prop("checked")) {
      $(".toggle input").prop("checked", true);
    } else {
      $(".toggle input").prop("checked", false);
    }
  });

  let timer;
  $('.auto-save').on('keyup', function() {
    clearTimeout(timer); // 以前のタイマーをクリア
    // 5秒後に処理を実行
    let postData = {
      "work_content": "",
      "content": "",
      "study_content": "",
      "notices_content": "",
      // 暫定対応：ルーティングを分けるから今後不要
      "type": "auto"
    };
    timer = setTimeout(function() {
      // 暫定対応
        postData.work_content = $('textarea[name="work_content"]').val() == "" ? "未入力" : $('textarea[name="work_content"]').val();
        postData.content = $('textarea[name="content"]').val() == "" ? "未入力" : $('textarea[name="content"]').val();
        postData.study_content = $('textarea[name="study_content"]').val() == "" ? "未入力" : $('textarea[name="study_content"]').val();
        postData.notices_content = $('textarea[name="notices_content"]').val() == "" ? "未入力" : $('textarea[name="notices_content"]').val();
        autoSave(postData);
    }, 5000);
  });

  function autoSave (postData) {
    console.log(postData);
    url = $(".post-form").attr('action');
    $.ajax({
      url: url,
      type: 'POST',
      // dataはハッシュで指定
      data: postData,
      dataType: "json"
    });
  };
});