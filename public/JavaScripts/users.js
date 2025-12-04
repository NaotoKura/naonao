$(function() {
  // ユーザー一覧画面のクリアボタン
  $(document).ready(function(){
    $(".clearForm").bind("click", function(){
      $(this.form).find("input:text, #ages, #birth2, #birth3, #prefecture")
      .val("").end().find(":checked").prop("checked", false);
      $('#pageForm').submit();
    });
  });

  // ユーザ詳細画面への動線
  $('tr[data-href]').click(function () {
    window.location = $(this).closest('tr').data('href');
  });

  // ユーザー一覧画面の期間のチェックボックス複数選択不可にする
  $('.check-period').on('click', function() {
    if ($(this).prop('checked')){
      // 一旦全てをクリアして再チェックする
      $('.check-period').prop('checked', false);
      $(this).prop('checked', true);
    }
  });

  // アカウント編集画面の年齢に半角数字のみを入力させる
  $('#age').on('input', function() {
    //inputイベントはあまり見かけないが、これはリアルタイムでinputの入力値を取得できるイベント
    let value = $(this).val();
    //入力値を取得している。val()はinputの入力値を取得するメソッド。inputイベントと合わせることでリアルタイムで入力された文字を取得。
    value = value.replace(/[０-９]/g, function(s) {
      //.replaceは文字列を置換するメソッド。/[０-９]/gは正規表現で、全角数字の０から９に対して処理。その下の/[^0-9]/gは半角数字の0から9以外に対して処理。先頭の^は正規表現では否定という意味を持つ。
        return String.fromCharCode(s.charCodeAt(0) - 65248);
        //.replaceは文字列を置換するメソッドです。/[０-９]/gは正規表現で、全角数字の０から９に対して処理。その下の/[^0-9]/gは半角数字の0から9以外に対して処理。先頭の^は正規表現では否定という意味を持つ。
      })
      .replace(/[^0-9]/g, '');
    $(this).val(value);
  });

  // アカウント編集画面の性別のチェックボックスを複数選択不可にする
  $('.check-gender').on('click', function() {
    if ($(this).prop('checked')){
      // 一旦全てをクリアして再チェックする
      $('.check-gender').prop('checked', false);
      $(this).prop('checked', true);
    }
  });

  // アカウント編集画面の削除時のダイアログ
  $('#discard_btn').click(function () {
    if (window.confirm('本当に削除してもよろしいですか？')) {
      $('#discard_btn').submit();
    }
  });
});
