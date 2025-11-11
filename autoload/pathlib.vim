" @file
"   pathlib.vim - miscellaneous filesystem utilities
"
" @author
"   Tyler Carbone <tcarbone073@gmail.com>
"
"

" ==============================================================================
" private


function! s:resolve(path)
    if a:path == ''
        return expand("%:p")
    endif

    return a:path
endfunction


function! s:ensure_dir(path)
    let l:resolved = s:resolve(a:path)

    if isdirectory(l:resolved)
        return l:resolved
    endif

    echo 'Error: must be directory'
    return ''
endfunction


" ==============================================================================
" components


" absolute
function! pathlib#absolute()
    return expand("%:p")
endfunction


" name
function! pathlib#name(path = '')
    return fnamemodify(s:resolve(a:path), ":t")
endfunction


" tail
function! pathlib#tail(path = '')
    return substitute(s:resolve(a:path), '^.\{-1,}\.', '', '')
endfunction


" suffix
function! pathlib#suffix(path = '')
    return fnamemodify(s:resolve(a:path), ":e")
endfunction


" stem
function! pathlib#stem(path = '')
    return fnamemodify(s:resolve(a:path), ":t:r")
endfunction


" parent
function! pathlib#parent(path = '')
    return pathlib#parents(a:path)[0]
endfunction


" trunk
function! pathlib#trunk(path = '')
    return pathlib#join(pathlib#parent(a:path), pathlib#stem(a:path))
endfunction


" suffixes
function! pathlib#suffixes(path = '')
    return split(pathlib#tail(a:path), '\.')
endfunction


" parents
function! pathlib#parents(path = '')
    let l:path = s:resolve(a:path)

    let l:parents = []

    while 1
        let l:parent = fnamemodify(l:path, ":h")

        call add(l:parents, l:parent)

        if l:parent == "/"
            break
        else
            let l:path = l:parent
        endif
    endwhile

    return l:parents
endfunction


" children
function! pathlib#children(root, maxdepth = 2)
    let l:children = []

    for l:child in readdir(a:root)
        let l:child = pathlib#join(a:root, l:child)

        call add(l:children, l:child)

        if isdirectory(l:child) && a:maxdepth > 0
            call extend(l:children, pathlib#children(l:child, a:maxdepth - 1))
        endif
    endfor

    return l:children
endfunction


" ==============================================================================
" modifiers


" with_name
function pathlib#with_name(name, path = '')
    return pathlib#join(pathlib#parent(a:path), a:name)
endfunction


" with_tail
function! pathlib#with_tail(tail, path = '')
    return pathlib#trunk(a:path) .. '.' .. a:tail
endfunction


" with_suffix


" with_stem
function pathlib#with_stem(stem, path = '')
    let l:parent = pathlib#parent(a:path)
    let l:tail = pathlib#tail(a:path)
    return pathlib#join(l:parent, a:stem) .. '.' .. l:tail
endfunction


" join
function! pathlib#join(...)
    return join(a:000, "/")
endfunction


" ==============================================================================
" tests


" exists
function! pathlib#exists(path = '')
    return filereadable(s:resolve(a:path))
endfunction


" ==============================================================================
" finding


" ff_u
function! pathlib#ff_u(name, root = '', stop = '')
    let l:root = s:ensure_dir(a:root)
    let l:file = findfile(a:name, l:root .. ';' .. a:stop)

    if l:file == ''
        call utils#error($"no such file: {a:name} (searching UP from {l:root}, ending at {a:stop})")
    endif

    return l:file
endfunction


" ff_d
function pathlib#ff_d(name, root = '', maxdepth = 2)
    let l:root = s:ensure_dir(a:root)
    let l:file = findfile(a:name, l:root .. '/**' .. a:maxdepth)

    if l:file == ''
        call utils#error($"no such file: {a:name} (searching DOWN, descending {a:maxdepth} subdirs)")
    endif

    return l:file
endfunction


" ff
function pathlib#ff(name, root = '', stop = '', maxdepth = 2)
    let l:root = s:ensure_dir(a:root)

    " Search UP
    let l:file = findfile(a:name, l:root .. ';' .. a:stop)

    if l:file == ''
        " Search DOWN
        let l:file = findfile(a:name, l:root .. '/**' .. a:maxdepth)
    endif

    if l:file == ''
        call utils#error($"no such file: {a:name} (searching UP and DOWN)")
    endif

    return l:file
endfunction


" edit
function! pathlib#edit(path)
    if !filereadable(a:path)
        call utils#error($"file not readable: {a:path}")
        return 1
    endif

    execute "edit " .. fnameescape(a:path)
    return 0
endfunction
