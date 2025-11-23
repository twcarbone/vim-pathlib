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

function! Test_name()
    call assert_equal('pkg.tar.gz', pathlib#name(s:p1))
    call assert_equal('user', pathlib#name(s:p2))
    call assert_equal('user', pathlib#name(s:p3))
    call assert_equal('known_hosts', pathlib#name(s:p4))
    call assert_equal('.tmux.conf', pathlib#name(s:p5))
    call assert_equal('.vimrc', pathlib#name(s:p6))
    call assert_equal('epel.repo', pathlib#name(s:p7))
    call assert_equal('', pathlib#name(s:p8))
endfunction

function! Test_name_emptypath()
    call assert_equal('test_components.vim', pathlib#name())
endfunction

function! Test_tail()
    call assert_equal('tar.gz', pathlib#tail(s:p1))
    call assert_equal('', pathlib#tail(s:p2))
    call assert_equal('', pathlib#tail(s:p3))
    call assert_equal('', pathlib#tail(s:p4))
    call assert_equal('conf', pathlib#tail(s:p5))
    call assert_equal('', pathlib#tail(s:p6))
    call assert_equal('repo', pathlib#tail(s:p7))
    call assert_equal('', pathlib#tail(s:p8))
endfunction

function! Test_tail_emptypath()
    call assert_equal('vim', pathlib#tail())
endfunction

function! Test_suffix()
    call assert_equal('gz', pathlib#suffix(s:p1))
    call assert_equal('', pathlib#suffix(s:p2))
    call assert_equal('', pathlib#suffix(s:p3))
    call assert_equal('', pathlib#suffix(s:p4))
    call assert_equal('conf', pathlib#suffix(s:p5))
    call assert_equal('', pathlib#suffix(s:p6))
    call assert_equal('repo', pathlib#suffix(s:p7))
    call assert_equal('', pathlib#suffix(s:p8))
endfunction

function! Test_suffix_emptypath()
    call assert_equal('vim', pathlib#suffix())
endfunction

function! Test_stem()
    call assert_equal('pkg', pathlib#stem(s:p1))
    call assert_equal('user', pathlib#stem(s:p2))
    call assert_equal('user', pathlib#stem(s:p3))
    call assert_equal('known_hosts', pathlib#stem(s:p4))
    call assert_equal('.tmux', pathlib#stem(s:p5))
    call assert_equal('.vimrc', pathlib#stem(s:p6))
    call assert_equal('epel', pathlib#stem(s:p7))
    call assert_equal('', pathlib#stem(s:p8))
endfunction

function! Test_stem_emptypath()
    call assert_equal('test_components', pathlib#stem())
endfunction

function! Test_parent()
    call assert_equal('/home/user', pathlib#parent(s:p1))
    call assert_equal('/home', pathlib#parent(s:p2))
    call assert_equal('/home', pathlib#parent(s:p3))
    call assert_equal('/home/user/.ssh', pathlib#parent(s:p4))
    call assert_equal('/home/user/.config', pathlib#parent(s:p5))
    call assert_equal('/home/user', pathlib#parent(s:p6))
    call assert_equal('/etc/yum.repos.d', pathlib#parent(s:p7))
    call assert_equal('/', pathlib#parent(s:p8))
endfunction

function! Test_parent_emptypath()
    call assert_equal('/tmp/vimtest', pathlib#parent())
endfunction

function! Test_trunk()
    call assert_equal('/home/user/pkg', pathlib#trunk(s:p1))
    call assert_equal('/home/user', pathlib#trunk(s:p2))
    call assert_equal('/home/user', pathlib#trunk(s:p3))
    call assert_equal('/home/user/.ssh/known_hosts', pathlib#trunk(s:p4))
    call assert_equal('/home/user/.config/.tmux', pathlib#trunk(s:p5))
    call assert_equal('/home/user/.vimrc', pathlib#trunk(s:p6))
    call assert_equal('/etc/yum.repos.d/epel', pathlib#trunk(s:p7))
    call assert_equal('/', pathlib#trunk(s:p8))
endfunction

function! Test_trunk_emptypath()
    call assert_equal('/tmp/vimtest/test_components', pathlib#trunk())
endfunction

function! Test_suffixes()
    call assert_equal(['tar', 'gz'], pathlib#suffixes(s:p1))
    call assert_equal([], pathlib#suffixes(s:p2))
    call assert_equal([], pathlib#suffixes(s:p3))
    call assert_equal([], pathlib#suffixes(s:p4))
    call assert_equal(['conf'], pathlib#suffixes(s:p5))
    call assert_equal([], pathlib#suffixes(s:p6))
    call assert_equal(['repo'], pathlib#suffixes(s:p7))
    call assert_equal([], pathlib#suffixes(s:p8))
endfunction

function! Test_suffixes_emptypath()
    call assert_equal(['vim'], pathlib#suffixes())
endfunction

function! Test_parents()
    call assert_equal(['/home/user', '/home', '/'], pathlib#parents(s:p1))
    call assert_equal(['/home', '/'], pathlib#parents(s:p2))
    call assert_equal(['/home', '/'], pathlib#parents(s:p3))
    call assert_equal(['/home/user/.ssh', '/home/user', '/home', '/'], pathlib#parents(s:p4))
    call assert_equal(['/home/user/.config', '/home/user', '/home', '/'], pathlib#parents(s:p5))
    call assert_equal(['/home/user', '/home', '/'], pathlib#parents(s:p6))
    call assert_equal(['/etc/yum.repos.d', '/etc', '/'], pathlib#parents(s:p7))
    call assert_equal(['/'], pathlib#parents(s:p8))
endfunction

function! Test_parents_emptypath()
    call assert_equal(['/tmp/vimtest', '/tmp', '/'], pathlib#parents())
endfunction
