if exists('g:autoloaded_db_elasticsearch')
  finish
endif
let g:autoloaded_db_elasticsearch = 1

function! db#adapter#elasticsearch#input_extension() abort
  return 'elasticsearch'
endfunction

function! s:command_for_request(method, url, path, payload = '') abort
  let host = db#url#parse(a:url).opaque
  let cmd = ['curl', '-s', '-X'.a:method, '-H', 'Content-Type: application/json', host.'/'.a:path]
  if !empty(a:payload)
    let cmd += ['-d\''.a:payload.'\'']
  endif
  return cmd
endfunction

function! db#adapter#elasticsearch#command(url) abort
  return s:command_for_request('GET', a:url, '')
endfunction

function! db#adapter#elasticsearch#interactive(url) abort
  return db#adapter#elasticsearch#command(a:url)
endfunction

function! db#adapter#elasticsearch#tables(url) abort
  return db#systemlist(s:command_for_request('GET', a:url, '_cat/indices?h=index'))
endfunction

function! db#adapter#elasticsearch#massage(input) abort
  return a:input . "\n;"
endfunction

