function! fold_surround#hello() "  
    echo 'hello'
endfunction
" 
function! fold_surround#SurroundWithNamedFold() "  
    "   aquire needed strings!
    let first_line_whitespace = matchstr(getline("'<"),"^\\s*")
    let foldDescription = input("Fold description! ")
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    " 
    "   add foldmarkers!
    call append(line("'<")-1, first_line_whitespace.left_foldmarker." ".foldDescription)
    call append(line("'>"), first_line_whitespace.right_foldmarker)
    " 
    "   refresh folds!
    execute "normal! zMzvzc"
    " 
endfunction " 
function! fold_surround#SurroundWithUnnamedFold() "  
    "   make sure we have <2 lines!
    "if getline("'<")==getline("'>")
    "   echo "Select at least two lines"
    "   return 0
    "endif
    " 
    "   aquire needed strings!
    let first_line = getline("'<")
    let first_line_whitespace = matchstr(getline("'<"),"^\\s*")
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    " 
    "   add foldmarkers!
    call setline(line("'<"), first_line." ".left_foldmarker)
    call append(line("'>"), first_line_whitespace.right_foldmarker)
    " 
    "   refresh folds
    execute "normal! zMzvzc"
    " 
endfunction " 
function! fold_surround#CustomFoldText() "  
    let display_line_number=v:foldstart
    let display_line=getline(display_line_number)
    let ick_found=(-1!=match(display_line, g:fold_surround_title_discriminator))
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    if !ick_found && match(display_line, '^\s*'.&foldmarker[0].'\s*') != -1
        return matchstr(foldtext(), "^.\\{-}:").matchlist(display_line, left_foldmarker.'\(.*\)')[1]
    endif
    while ick_found
        let display_line_number=display_line_number + 1
        let display_line=getline(display_line_number)
        let ick_found=(-1!=match(display_line, g:fold_surround_title_discriminator))
    endwhile
    return matchstr(foldtext(), "^.\\{-}:")." ".matchstr(display_line,"\\w.*")
    "if ick_found
    "    let return_value="ick: ".display_line
    "else
    "    let return_value="good: ".display_line
    "endif
    "return return_value
endfunction
" 
