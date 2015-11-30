augroup plugin-POWER-mode
    autocmd!
    autocmd TextChangedI * call s:shake()
    autocmd CursorHold,CursorHoldI * call s:restore_pos()
augroup END

command! ShakeOn call s:switch(1)
command! ShakeOff call s:switch(0)

set updatetime=60

let s:amplitude = 5
let s:state = 0

let s:seed = 0
function! s:rand() abort
  let s:seed = s:seed * 214013 + 2531011
  return (s:seed < 0 ? s:seed - 0x80000000 : s:seed) / 0x10000 % 0x8000
endfunction

function! s:switch(state)
    let s:state = a:state
endfunction

function! s:random_direction() abort
    let rad = s:rand() % 1000 / 1000.0 * 44 / 7
    if exists('g:shake#amplitude')
        let len = g:shake#amplitude
    else
        let len = s:amplitude
    endif
    let x = float2nr(round(len * cos(rad)))
    let y = float2nr(round(len * sin(rad)))
    return [x, y]
endfunction

function! s:Power()
    echom 'power'
endfunction

function! s:restore_pos() abort
    if exists('s:winpos')
        execute 'winpos' s:winpos[0] s:winpos[1]
        unlet! s:winpos
    endif
endfunction

function! s:shake() abort
    if !exists('s:state') || !s:state
        return
    endif
    if !exists('s:winpos')
        let s:winpos = [getwinposx(), getwinposy()]
    endif

    let d = s:random_direction()
    execute 'winpos' (s:winpos[0] + d[0]) (s:winpos[1] + d[1])
endfunction
