let s:shaking = 0

augroup plugin-POWER-mode
    autocmd!
    autocmd TextChangedI * call s:shake()
    autocmd CursorHold,CursorHoldI * call s:restore_pos()
augroup END

set updatetime=100

let s:seed = 0
function! s:rand() abort
  let s:seed = s:seed * 214013 + 2531011
  return (s:seed < 0 ? s:seed - 0x80000000 : s:seed) / 0x10000 % 0x8000
endfunction

function! s:random_direction() abort
    let x = s:rand() % 10
    let y = s:rand() % 10
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
    if exists('s:winpos')
        return
    endif

    let s:winpos = [getwinposx(), getwinposy()]
    let d = s:random_direction()
    execute 'winpos' (getwinposx() + d[0]) (getwinposy() + d[1])
endfunction
