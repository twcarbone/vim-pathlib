function! SetUp()
    call system('mkdir -p /tmp/vimtest/a/b/c/d')
    call system('touch /tmp/vimtest/1')
    call system('touch /tmp/vimtest/a/b/c/d/2')
    call system('touch /tmp/vimtest/a/b/3')
endfunction

function! TearDown()
    " /tmp/vimtest is removed in test/Makefile 'clean'
endfunction

function! Test_ff_u()
    call assert_equal('',               pathlib#ff_u('1', '/tmp/vimtest/a/b/c/d', '/tmp/vimtest/a'))
    call assert_equal('',               pathlib#ff_u('1', '/tmp/vimtest/a/b/c/d', '/tmp/vimtest/a/b'))
    call assert_equal('/tmp/vimtest/1', pathlib#ff_u('1', '/tmp/vimtest'))
    call assert_equal('/tmp/vimtest/1', pathlib#ff_u('1', '/tmp/vimtest/a'))
    call assert_equal('/tmp/vimtest/1', pathlib#ff_u('1', '/tmp/vimtest/a/b/c/d'))
    call assert_equal('/tmp/vimtest/1', pathlib#ff_u('1', '/tmp/vimtest/a/b/c/d', '/tmp'))
    call assert_equal('/tmp/vimtest/1', pathlib#ff_u('1', '/tmp/vimtest/a/b/c/d', '/tmp/vimtest'))
endfunction

function! Test_ff_d()
    call assert_equal('',                       pathlib#ff_d('2', '/tmp/vimtest', 3))
    call assert_equal('',                       pathlib#ff_d('2', '/tmp/vimtest/a/b/c', 0))
    call assert_equal('/tmp/vimtest/a/b/c/d/2', pathlib#ff_d('2', '/tmp/vimtest', 4))
    call assert_equal('/tmp/vimtest/a/b/c/d/2', pathlib#ff_d('2', '/tmp/vimtest/a/b/c', 1))
    call assert_equal('/tmp/vimtest/a/b/c/d/2', pathlib#ff_d('2', '/tmp/vimtest/a/b/c/d'))
    call assert_equal('/tmp/vimtest/a/b/c/d/2', pathlib#ff_d('2', '/tmp/vimtest/a/b/c/d', 0))
endfunction

function! Test_ff()
    call assert_equal('',                   pathlib#ff('3', '/tmp/vimtest/a/b/c/d', '/tmp/vimtest/a/b/c'))
    call assert_equal('',                   pathlib#ff('3', '/tmp/vimtest', '', 1))
    call assert_equal('/tmp/vimtest/a/b/3', pathlib#ff('3', '/tmp/vimtest/a/b/c/d'))
    call assert_equal('/tmp/vimtest/a/b/3', pathlib#ff('3', '/tmp/vimtest'))
endfunction
