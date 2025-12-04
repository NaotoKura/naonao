$(function () {
  var user = 'users'
  var post = 'posts'
  let path = location.pathname;
  num = path.replace(/[^0-9]/g, '');
  if(num.length && path.includes(user)){
    url = '/users/'+num+'/edit'
    history.replaceState('', '', url)
  } else if(num.length && path.includes(post)){
    url = '/posts/'+num+'/edit'
    history.replaceState('', '', url)
  } else if (path.includes(post)){
    history.replaceState('', '', '/posts/new')
  } else {
    history.replaceState('', '', '/signup')
  }
});
