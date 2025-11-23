function! SetUp()
    let s:p1 = '/home/user/pkg.tar.gz'
    let s:p2 = '/home/user/'
    let s:p3 = '/home/user'
    let s:p4 = '/home/user/.ssh/known_hosts'
    let s:p5 = '/home/user/.config/.tmux.conf'
    let s:p6 = '/home/user/.vimrc'
    let s:p7 = '/etc/yum.repos.d/epel.repo'
    let s:p8 = '/'
endfunction

function! TearDown()
endfunction

function! Test_with_name()
    call assert_equal('/home/user/main.c', pathlib#with_name('main.c', s:p1))
    call assert_equal('/home/foo', pathlib#with_name('foo', s:p2))
    call assert_equal('/home/bar', pathlib#with_name('bar', s:p3))
    call assert_equal('/home/user/.ssh/config', pathlib#with_name('config', s:p4))
    call assert_equal('/home/user/.config/.bashrc', pathlib#with_name('.bashrc', s:p5))
    call assert_equal('/home/user/.git', pathlib#with_name('.git', s:p6))
    call assert_equal('/etc/yum.repos.d/redhat.repo', pathlib#with_name('redhat.repo', s:p7))
    call assert_equal('/bin', pathlib#with_name('bin', s:p8))
endfunction

function! Test_with_name_emptypath()
    call assert_equal('/tmp/vimtest/a.b', pathlib#with_name('a.b'))
endfunction

function Test_with_tail()
    call assert_equal('/home/user/pkg.bak.1', pathlib#with_tail('bak.1', s:p1))
    call assert_equal('/home/user.d', pathlib#with_tail('d', s:p2))
    call assert_equal('/home/user.d', pathlib#with_tail('d', s:p3))
    call assert_equal('/home/user/.ssh/known_hosts.txt', pathlib#with_tail('txt', s:p4))
    call assert_equal('/home/user/.config/.tmux.spam', pathlib#with_tail('spam', s:p5))
    call assert_equal('/home/user/.vimrc.bak.2', pathlib#with_tail('bak.2', s:p6))
    call assert_equal('/etc/yum.repos.d/epel.bak', pathlib#with_tail('bak', s:p7))

    try
        call pathlib#with_tail('baz', s:p8)
    catch
        call assert_exception('cannot add a tail to path with no stem: /')
    endtry
endfunction

function! Test_with_tail_emptypath()
    call assert_equal('/tmp/vimtest/test_modifiers.a.b', pathlib#with_tail('a.b'))
endfunction

function Test_with_suffix()
    call assert_equal('/home/user/pkg.tar.bz2', pathlib#with_suffix('bz2', s:p1))
    call assert_equal('/home/user.foo', pathlib#with_suffix('foo', s:p2))
    call assert_equal('/home/user.bar', pathlib#with_suffix('bar', s:p3))
    call assert_equal('/home/user/.ssh/known_hosts.txt', pathlib#with_suffix('txt', s:p4))
    call assert_equal('/home/user/.config/.tmux.conf2', pathlib#with_suffix('conf2', s:p5))
    call assert_equal('/home/user/.vimrc.old', pathlib#with_suffix('old', s:p6))
    call assert_equal('/etc/yum.repos.d/epel.oper', pathlib#with_suffix('oper', s:p7))

    try
        call pathlib#with_suffix('gz.old', s:p1)
    catch
        call assert_exception('suffix cannot contain dots: gz.old')
    endtry

    try
        call pathlib#with_suffix('txt', s:p8)
    catch
        call assert_exception('cannot add a suffix to path with no stem: /')
    endtry
endfunction

function! Test_with_suffix_emptypath()
    call assert_equal('/tmp/vimtest/test_modifiers.txt', pathlib#with_suffix('txt'))

    try
        call pathlib#with_suffix('a.b')
    catch
        call assert_exception('suffix cannot contain dots: a.b')
    endtry
endfunction

function Test_with_stem()
    call assert_equal('/home/user/ncurses.tar.gz', pathlib#with_stem('ncurses', s:p1))
    call assert_equal('/home/osi', pathlib#with_stem('osi', s:p2))
    call assert_equal('/home/osi', pathlib#with_stem('osi', s:p3))
    call assert_equal('/home/user/.ssh/config', pathlib#with_stem('config', s:p4))
    call assert_equal('/home/user/.config/bar.conf', pathlib#with_stem('bar', s:p5))
    call assert_equal('/home/user/.foo', pathlib#with_stem('.foo', s:p6))
    call assert_equal('/etc/yum.repos.d/redhat.repo', pathlib#with_stem('redhat', s:p7))
    call assert_equal('/var', pathlib#with_stem('var', s:p8))

    try
        call pathlib#with_stem('foo.bar', s:p2)
    catch
        call assert_exception('dots only allowed at index 0: foo.bar')
    endtry
endfunction

function! Test_with_stem_emptypath()
    call assert_equal('/tmp/vimtest/f.vim', pathlib#with_stem('f'))
endfunction

function Test_join()
    call assert_equal('/foo/bar/baz.txt', pathlib#join('/foo', 'bar', 'baz.txt'))
    call assert_equal('/foo/bar/baz.txt', pathlib#join('/foo/', '/bar', '', '/', '', 'baz.txt'))
    call assert_equal('/', pathlib#join('/', '/', '/'))
    call assert_equal('bar/baz.txt', pathlib#join('bar', 'baz.txt'))
endfunction
