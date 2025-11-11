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
    "   deal with the top line being displayable!
    "   deal with the foldmarker being the end of the line
    if !ick_found && match(display_line, '^\s*'.left_foldmarker) != -1
        return matchstr(foldtext(), "^.\\{-}:").matchlist(display_line, left_foldmarker.'\(.*\)')[1]
    endif
    " 
    "   deal with the foldmarker being the start of the line
    if !ick_found && match(display_line, left_foldmarker.'\s*$') != -1
        return matchstr(foldtext(), "^.\\{-}:")." ".matchlist(display_line, '\(.*\)'.left_foldmarker)[1]
    endif
    " 
    " 
    "   deal with the top line being bad
    "   skip over the bad lines!
    while ick_found
        let display_line_number=display_line_number + 1
        let display_line=getline(display_line_number)
        let ick_found=(-1!=match(display_line, g:fold_surround_title_discriminator))
    endwhile
    " 
    "   display the first line that isn't skipped!
    return matchstr(foldtext(), "^.\\{-}:")." ".matchstr(display_line,"\\w.*")
    " 
    " 
endfunction
" 
