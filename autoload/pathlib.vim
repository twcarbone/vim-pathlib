" @file
"   pathlib.vim - miscellaneous filesystem utilities
"
" @author
"   Tyler Carbone <tcarbone073@gmail.com>
"

" ==============================================================================
" private


function! s:resolve(path)
    let l:path = a:path
    if l:path == ''
        let l:path = expand("%:p")
    endif

    if l:path == '/'
        return l:path
    endif

    return substitute(l:path, '/$', '', '')
endfunction


function! s:ensure_dir(path)
    let l:resolved = s:resolve(a:path)

    if isdirectory(l:resolved)
        return l:resolved
    endif

    echo 'Error: must be directory'
    return ''
endfunction


function! s:validate_name(component)
    if match(a:component, '/') != -1
        throw $"cannot contain slashes: ${a:component}"
    endif
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
    let l:name = pathlib#name(a:path)
    let l:idx = match(l:name, '\.', 1)
    if l:idx == -1
        return ''
    else
        return l:name[l:idx + 1:]
    endif
endfunction


" suffix
function! pathlib#suffix(path = '')
    return fnamemodify(s:resolve(a:path), ":e")
endfunction


" stem
function! pathlib#stem(path = '')
    let l:name = pathlib#name(a:path)
    let l:idx = match(l:name, '\.', 1)
    if l:idx == -1
        return l:name
    else
        return l:name[0:l:idx - 1]
    endif
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
    call s:validate_name(a:name)

    return pathlib#join(pathlib#parent(a:path), a:name)
endfunction


" with_tail
function! pathlib#with_tail(tail, path = '')
    call s:validate_name(a:tail)

    if pathlib#stem(a:path) == ''
        throw $"cannot add a tail to path with no stem: {a:path}"
    endif

    return pathlib#trunk(a:path) .. '.' .. a:tail
endfunction


" with_suffix
function! pathlib#with_suffix(suffix, path = '')
    call s:validate_name(a:suffix)

    if match(a:suffix, '\.') != -1
        throw $"suffix cannot contain dots: {a:suffix}"
    endif

    if pathlib#stem(a:path) == ''
        throw $"cannot add a suffix to path with no stem: {a:path}"
    endif

    let l:suffix = pathlib#suffix(a:path)

    if l:suffix == ''
        return pathlib#with_tail(a:suffix, a:path)
    else
        return substitute(a:path, pathlib#suffix(a:path) .. '$', a:suffix, '')
    endif
endfunction


" with_stem
function pathlib#with_stem(stem, path = '')
    call s:validate_name(a:stem)

    if match(a:stem, '\.') > 0
        throw $"dots only allowed at index 0: {a:stem}"
    endif

    let l:path = pathlib#join(pathlib#parent(a:path), a:stem)

    let l:tail = pathlib#tail(a:path)
    if l:tail != ''
        let l:path = l:path .. '.' .. l:tail
    endif

    return l:path
endfunction


" join
function! pathlib#join(...)
    " 1. Start by naively joining all elements
    let l:path = join(a:000, '/')
    " 2. Compress any run of multiple / into a single /
    return substitute(l:path, '/\{2,}', '/', 'g')
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
