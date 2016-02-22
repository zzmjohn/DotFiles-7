" Fsep && Psep
if has('win16') || has('win32') || has('win64')
    let s:Psep = ';'
    let s:Fsep = '\'
else
    let s:Psep = ':'
    let s:Fsep = '/'
endif
" auto install plugin manager
if g:settings.plugin_manager == 'neobundle'
    "auto install neobundle
    if filereadable(expand(g:settings.plugin_bundle_dir) . 'neobundle.vim'. s:Fsep. 'README.md')
        let g:settings.neobundle_installed = 1
    else
        if executable('git')
            exec '!git clone https://github.com/Shougo/neobundle.vim ' . g:settings.plugin_bundle_dir . 'neobundle.vim'
            let g:settings.neobundle_installed = 1
        else
            echohl WarningMsg | echom "You need install git!" | echohl None
        endif
    endif
    exec 'set runtimepath+='.g:settings.plugin_bundle_dir . 'neobundle.vim'
elseif g:settings.plugin_manager == 'dein'
    "auto install dein
    if filereadable(expand(g:settings.plugin_bundle_dir) . 'dein.vim'. s:Fsep. 'README.md')
        let g:settings.dein_installed = 1
    else
        if executable('git')
            exec '!git clone https://github.com/Shougo/dein.vim ' . g:settings.plugin_bundle_dir . 'dein.vim'
            let g:settings.dein_installed = 1
        else
            echohl WarningMsg | echom "You need install git!" | echohl None
        endif
    endif
    exec 'set runtimepath+='.g:settings.plugin_bundle_dir . 'dein.vim'
elseif g:settings.plugin_manager == 'vim-plug'
    "auto install vim-plug
    if filereadable(expand('~/.cache/vim-plug/autoload/plug.vim'))
        let g:settings.dein_installed = 1
    else
        if executable('curl')
            exec '!curl -fLo ~/.cache/vim-plug/autoload/plug.vim --create-dirs '
                        \. 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            let g:settings.dein_installed = 1
        else
            echohl WarningMsg | echom "You need install curl!" | echohl None
        endif
    endif
    exec 'set runtimepath+=~/.cache/vim-plug/'
endif

"init manager func

fu! s:begin(path)
    if g:settings.plugin_manager == 'neobundle'
        call neobundle#begin(a:path)
    elseif g:settings.plugin_manager == 'dein'
        call dein#begin(a:path)
    elseif g:settings.plugin_manager == 'vim-plug'
        call plug#begin(a:path)
    endif
endf

fu! s:end()
    if g:settings.plugin_manager == 'neobundle'
        call neobundle#end()
        NeoBundleCheck
    elseif g:settings.plugin_manager == 'dein'
        call dein#end()
    elseif g:settings.plugin_manager == 'vim-plug'
        call plug#end()
    endif
endf

fu! s:parser(args)
endf

fu! s:add(repo,...)
    if g:settings.plugin_manager == 'neobundle'
        exec 'NeoBundle "'.a:repo.'"'.','.join(a:000,',')
    elseif g:settings.plugin_manager == 'dein'
        call dein#add(a:repo)
    endif
endf
fu! s:tap(plugin)
    if g:settings.plugin_manager == 'neobundle'
        return neobundle#tap(a:plugin)
    elseif g:settings.plugin_manager == 'dein'
        return dein#tap(a:plugin)
    endif
endf
fu! s:defind_hooks(bundle)
    if g:settings.plugin_manager == 'neobundle'
        let s:hooks = neobundle#get_hooks(a:bundle)
        func! s:hooks.on_source(bundle) abort
            call zvim#util#source_rc('plugins/' . split(a:bundle['name'],'\.')[0] . '.vim')
        endf
    elseif g:settings.plugin_manager == 'dein'
    endif
endf
fu! s:fetch()
    if g:settings.plugin_manager == 'neobundle'
        NeoBundleFetch 'Shougo/neobundle.vim'
    elseif g:settings.plugin_manager == 'dein'
        call dein#add('Shougo/dein.vim')
    endif
endf

fu! s:enable_plug()
    return g:settings.neobundle_installed || g:settings.dein_installed || g:settings.vim_plug_installed
endf

"plugins and config
if s:enable_plug()
    call s:begin(g:settings.plugin_bundle_dir)
    call s:fetch()
    if count(g:settings.plugin_groups, 'core') "{{{
        call s:add('Shougo/vimproc.vim', {
                    \ 'build'   : {
                    \ 'windows' : 'tools\\update-dll-mingw',
                    \ 'cygwin'  : 'make -f make_cygwin.mak',
                    \ 'mac'     : 'make -f make_mac.mak',
                    \ 'linux'   : 'make',
                    \ 'unix'    : 'gmake',
                    \ },
                    \ })
    endif
    if count(g:settings.plugin_groups, 'nvim') "{{{
        call s:add('junegunn/vim-github-dashboard')
    endif
    if count(g:settings.plugin_groups, 'unite') "{{{
        call s:add('Shougo/unite.vim')
        if s:tap('unite.vim')
            call s:defind_hooks('unite.vim')
        endif
        call s:add('Shougo/neoyank.vim')
        call s:add('soh335/unite-qflist')
        call s:add('ujihisa/unite-equery')
        call s:add('m2mdas/unite-file-vcs')
        call s:add('Shougo/neomru.vim')
        call s:add('kmnk/vim-unite-svn')
        call s:add('basyura/unite-rails')
        call s:add('nobeans/unite-grails')
        call s:add('choplin/unite-vim_hacks')
        call s:add('mattn/webapi-vim')
        call s:add('mattn/wwwrenderer-vim')
        call s:add('thinca/vim-openbuf')
        call s:add('ujihisa/unite-haskellimport')
        call s:add('oppara/vim-unite-cake')
        call s:add('thinca/vim-ref')
        if s:tap('vim-ref')
            call s:defind_hooks('vim-ref')
        endif
        call s:add('heavenshell/unite-zf')
        call s:add('heavenshell/unite-sf2')
        call s:add('Shougo/unite-outline')
        call s:add('hewes/unite-gtags')
        if s:tap('unite-gtags')
            call s:defind_hooks('unite-gtags')
        endif
        call s:add('rafi/vim-unite-issue')
        call s:add('tsukkee/unite-tag')
        call s:add('ujihisa/unite-launch')
        call s:add('ujihisa/unite-gem')
        call s:add('osyo-manga/unite-filetype')
        call s:add('thinca/vim-unite-history')
        call s:add('Shougo/neobundle-vim-recipes')
        call s:add('Shougo/unite-help')
        call s:add('ujihisa/unite-locate')
        call s:add('kmnk/vim-unite-giti')
        call s:add('ujihisa/unite-font')
        call s:add('t9md/vim-unite-ack')
        call s:add('mileszs/ack.vim')
        call s:add('albfan/ag.vim')
        let g:ag_prg="ag  --vimgrep"
        let g:ag_working_path_mode="r"
        call s:add('dyng/ctrlsf.vim')
        if s:tap('ctrlsf.vim')
            call s:defind_hooks('ctrlsf.vim')
        endif
        call s:add('daisuzu/unite-adb')
        call s:add('osyo-manga/unite-airline_themes')
        call s:add('mattn/unite-vim_advent-calendar')
        call s:add('mattn/unite-remotefile')
        call s:add('sgur/unite-everything')
        call s:add('kannokanno/unite-dwm')
        call s:add('raw1z/unite-projects')
        call s:add('voi/unite-ctags')
        call s:add('Shougo/unite-session')
        call s:add('osyo-manga/unite-quickfix')
        call s:add('Shougo/vimfiler.vim')
        if s:tap('vimfiler.vim')
            call s:defind_hooks('vimfiler.vim')
        endif
        call s:add('mopp/googlesuggest-source.vim')
        call s:add('mattn/googlesuggest-complete-vim')
        call s:add('ujihisa/unite-colorscheme')
        call s:add('mattn/unite-gist')
        call s:add('tacroe/unite-mark')
        call s:add('tacroe/unite-alias')
        call s:add('tex/vim-unite-id')
        call s:add('sgur/unite-qf')
        call s:add('lambdalisue/unite-grep-vcs', {
                    \ 'autoload': {
                    \    'unite_sources': ['grep/git', 'grep/hg'],
                    \}})
        call s:add('klen/unite-radio.vim')
        "call s:add('ujihisa/quicklearn')
    endif "}}}


    "{{{ctrlpvim settings
    if count(g:settings.plugin_groups, 'ctrlp') "{{{
        call s:add('ctrlpvim/ctrlp.vim')
        if s:tap('ctrlp.vim')
            call s:defind_hooks('ctrlp.vim')
        endif
        call s:add('felixSchl/ctrlp-unity3d-docs')
        call s:add('voronkovich/ctrlp-nerdtree.vim')
        call s:add('elentok/ctrlp-objects.vim')
        call s:add('h14i/vim-ctrlp-buftab')
        call s:add('vim-scripts/ctrlp-cmdpalette')
        call s:add('mattn/ctrlp-windowselector')
        call s:add('the9ball/ctrlp-gtags')
        call s:add('thiderman/ctrlp-project')
        call s:add('mattn/ctrlp-google')
        call s:add('ompugao/ctrlp-history')
        call s:add('pielgrzym/ctrlp-sessions')
        call s:add('tacahiroy/ctrlp-funky')
        call s:add('brookhong/k.vim')
        call s:add('mattn/ctrlp-launcher')
        call s:add('sgur/ctrlp-extensions.vim')
        call s:add('FelikZ/ctrlp-py-matcher')
        call s:add('JazzCore/ctrlp-cmatcher')
        call s:add('ompugao/ctrlp-z')
    endif "}}}


    if count(g:settings.plugin_groups, 'autocomplete') "{{{
        call s:add('honza/vim-snippets')
        imap <silent><expr><TAB> MyTabfunc()
        smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
        inoremap <silent> <CR> <C-r>=MyEnterfunc()<Cr>
        inoremap <silent> <Leader><Tab> <C-r>=MyLeaderTabfunc()<CR>
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
        inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
        if g:settings.autocomplete_method == 'ycm' "{{{
            call s:add('SirVer/ultisnips')
            let g:UltiSnipsExpandTrigger="<tab>"
            let g:UltiSnipsJumpForwardTrigger="<tab>"
            let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
            let g:UltiSnipsSnippetsDir='~/DotFiles/snippets'
            call s:add('ervandew/supertab')
            let g:SuperTabContextDefaultCompletionType = "<c-n>"
            let g:SuperTabDefaultCompletionType = '<C-n>'
            autocmd InsertLeave * if pumvisible() == 0|pclose|endif
            let g:neobundle#install_process_timeout = 1500
            call s:add('Valloric/YouCompleteMe')
            "let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
            "let g:ycm_confirm_extra_conf = 0
            let g:ycm_collect_identifiers_from_tags_files = 1
            let g:ycm_collect_identifiers_from_comments_and_strings = 1
            let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>']
            let g:ycm_key_list_previous_completion = ['<C-S-TAB>','<Up>']
            let g:ycm_seed_identifiers_with_syntax = 1
            let g:ycm_key_invoke_completion = '<leader><tab>'
            let g:ycm_semantic_triggers =  {
                        \   'c' : ['->', '.'],
                        \   'objc' : ['->', '.'],
                        \   'ocaml' : ['.', '#'],
                        \   'cpp,objcpp' : ['->', '.', '::'],
                        \   'perl' : ['->'],
                        \   'php' : ['->', '::'],
                        \   'cs,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
                        \   'java,jsp' : ['.'],
                        \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
                        \   'ruby' : ['.', '::'],
                        \   'lua' : ['.', ':'],
                        \   'erlang' : [':'],
                        \ }
        elseif g:settings.autocomplete_method == 'neocomplete' "{{{
            call s:add('Shougo/neocomplete')
            if s:tap('neocomplete')
                call s:defind_hooks('neocomplete.vim')
            endif
        elseif g:settings.autocomplete_method == 'neocomplcache' "{{{
            call s:add('Shougo/neocomplcache.vim')
            if s:tap('neocomplcache.vim')
                call s:defind_hooks('neocomplcache.vim')
            endif
        elseif g:settings.autocomplete_method == 'deoplete'
            call s:add('Shougo/deoplete.nvim')
            if s:tap('deoplete.nvim')
                call s:defind_hooks('deoplete.nvim')
            endif
        endif "}}}
        call s:add('Shougo/neco-syntax')
        call s:add('ujihisa/neco-look')
        call s:add('Shougo/neco-vim')
        if !exists('g:necovim#complete_functions')
            let g:necovim#complete_functions = {}
        endif
        let g:necovim#complete_functions.Ref =
                    \ 'ref#complete'
        call s:add('Shougo/context_filetype.vim')
        call s:add('Shougo/neoinclude.vim')
        call s:add('Shougo/neosnippet-snippets')
        call s:add('Shougo/neosnippet.vim')
        if WINDOWS()
            let g:neosnippet#snippets_directory=g:Config_Main_Home .s:Fsep .'snippets'
        else
            let g:neosnippet#snippets_directory='~/DotFiles/snippets'
        endif
        let g:neosnippet#enable_snipmate_compatibility=1
        let g:neosnippet#enable_complete_done = 1
        let g:neosnippet#completed_pairs= {}
        let g:neosnippet#completed_pairs.java = {'(' : ')'}
        call s:add('Shougo/neopairs.vim')
        if g:neosnippet#enable_complete_done
            let g:neopairs#enable = 0
        endif
        imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
        smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    endif "}}}

    if count(g:settings.plugin_groups, 'colorscheme') "{{{
        "colorscheme
        call s:add('morhetz/gruvbox')
        call s:add('kabbamine/yowish.vim')
        call s:add('mhinz/vim-janah')
        call s:add('mhartington/oceanic-next')
        call s:add('nanotech/jellybeans.vim')
        call s:add('altercation/vim-colors-solarized')
        call s:add('kristijanhusak/vim-hybrid-material')
    endif

    if count(g:settings.plugin_groups, 'chinese') "{{{
        call s:add('vimcn/vimcdoc')
    endif

    if count(g:settings.plugin_groups, 'vim') "{{{
        call s:add('Shougo/vimshell.vim')
        call s:add('mattn/vim-terminal')
    endif
    call s:add('tpope/vim-scriptease')
    call s:add('tpope/vim-fugitive')
    call s:add('cohama/agit.vim')
    call s:add('gregsexton/gitv')
    call s:add('tpope/vim-surround')
    call s:add('terryma/vim-multiple-cursors')
    let g:multi_cursor_next_key='<C-j>'
    let g:multi_cursor_prev_key='<C-k>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'

    "web plugins

    call s:add('groenewege/vim-less', {'autoload':{'filetypes':['less']}})
    call s:add('cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss','sass']}})
    call s:add('hail2u/vim-css3-syntax', {'autoload':{'filetypes':['css','scss','sass']}})
    call s:add('ap/vim-css-color', {'autoload':{'filetypes':['css','scss','sass','less','styl']}})
    call s:add('othree/html5.vim', {'autoload':{'filetypes':['html']}})
    call s:add('wavded/vim-stylus', {'autoload':{'filetypes':['styl']}})
    call s:add('digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}})
    call s:add('juvenn/mustache.vim', {'autoload':{'filetypes':['mustache']}})
    call s:add('Valloric/MatchTagAlways')
    "call s:add('marijnh/tern_for_vim', {
    "\ 'autoload': { 'filetypes': ['javascript'] },
    "\ 'build': {
    "\ 'mac': 'npm install',
    "\ 'unix': 'npm install',
    "\ 'cygwin': 'npm install',
    "\ 'windows': 'npm install',
    "\ },
    "\ })
    call s:add('pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}})
    call s:add('maksimr/vim-jsbeautify', {'autoload':{'filetypes':['javascript']}})
    nnoremap <leader>fjs :call JsBeautify()<cr>
    call s:add('leafgarland/typescript-vim', {'autoload':{'filetypes':['typescript']}})
    call s:add('kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee']}})
    call s:add('mmalecki/vim-node.js', {'autoload':{'filetypes':['javascript']}})
    call s:add('leshill/vim-json', {'autoload':{'filetypes':['javascript','json']}})
    call s:add('othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','typescript']}})

    call s:add('artur-shaik/vim-javacomplete2')
    let g:JavaComplete_UseFQN = 1
    let g:JavaComplete_ServerAutoShutdownTime = 300
    let g:JavaComplete_MavenRepositoryDisable = 0
    call s:add('wsdjeg/vim-dict')
    call s:add('wsdjeg/java_getset.vim')
    if s:tap('java_getset.vim')
        let g:java_getset_disable_map = 1
    endif
    call s:add('wsdjeg/JavaUnit.vim')
    call s:add('jaxbot/github-issues.vim',{'on_cmd' : 'Gissues'})
    call s:add('wsdjeg/Mysql.vim')
    call s:add('vim-jp/vim-java')
    call s:add('vim-airline/vim-airline')
    call s:add('vim-airline/vim-airline-themes')
    if s:tap('vim-airline')
        call s:defind_hooks('vim-airline')
    endif
    call s:add('mattn/emmet-vim')
    let g:user_emmet_install_global = 0
    let g:user_emmet_leader_key='<C-e>'
    let g:user_emmet_mode='a'
    let g:user_emmet_settings = {
                \  'jsp' : {
                \      'extends' : 'html',
                \  },
                \}
    " use this two command to find how long the plugin take!
    "profile start vim-javacomplete2.log
    "profile! file */vim-javacomplete2/*
    if has('nvim') && g:settings.enable_neomake
        call s:add('wsdjeg/neomake')
        if s:tap('neomake')
            call s:defind_hooks('neomake')
        endif
    else
        call s:add('wsdjeg/syntastic')
        if s:tap('syntastic')
            call s:defind_hooks('syntastic')
        endif
    endif
    call s:add('syngan/vim-vimlint', {
                \ 'depends' : 'ynkdir/vim-vimlparser'})
    let g:syntastic_vimlint_options = {
                \'EVL102': 1 ,
                \'EVL103': 1 ,
                \'EVL205': 1 ,
                \'EVL105': 1 ,
                \}
    call s:add('ynkdir/vim-vimlparser')
    call s:add('todesking/vint-syntastic')
    "let g:syntastic_vim_checkers = ['vint']
    call s:add('gcmt/wildfire.vim')
    noremap <SPACE> <Plug>(wildfire-fuel)
    vnoremap <C-SPACE> <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']

    call s:add('scrooloose/nerdcommenter')
    call s:add('easymotion/vim-easymotion')
    call s:add('MarcWeber/vim-addon-mw-utils')
    "NeoBundle 'tomtom/tlib_vim'
    call s:add('mhinz/vim-startify')
    call s:add('mhinz/vim-signify')
    let g:signify_disable_by_default = 0
    let g:signify_line_highlight = 0
    call s:add('airblade/vim-rooter')
    let g:rooter_silent_chdir = 1
    call s:add('Yggdroot/indentLine')
    let g:indentLine_color_term = 239
    let g:indentLine_color_gui = '#09AA08'
    let g:indentLine_char = '¦'
    let g:indentLine_concealcursor = 'niv' " (default 'inc')
    let g:indentLine_conceallevel = 2  " (default 2)
    call s:add('godlygeek/tabular')
    call s:add('benizi/vim-automkdir')
    "[c  ]c  jump between prev or next hunk
    call s:add('airblade/vim-gitgutter')
    call s:add('itchyny/calendar.vim')
    "配合fcitx输入框架,在离开插入模式时自动切换到英文,在同一个缓冲区再次进入插入模式时回复到原来的输入状态
    call s:add('lilydjwg/fcitx.vim')
    call s:add('junegunn/goyo.vim')
    if s:tap('goyo.vim')
        call s:defind_hooks('goyo.vim')
    endif
    "vim Wimdows config
    "NeoBundle 'scrooloose/nerdtree'
    call s:add('tpope/vim-projectionist')
    call s:add('Xuyuanp/nerdtree-git-plugin')
    call s:add('taglist.vim')
    if s:tap('taglist.vim')
        call s:defind_hooks('taglist.vim')
    endif
    call s:add('ntpeters/vim-better-whitespace')
    call s:add('junegunn/rainbow_parentheses.vim')
    augroup rainbow_lisp
        autocmd!
        autocmd FileType lisp,clojure,scheme,java RainbowParentheses
    augroup END
    let g:rainbow#max_level = 16
    let g:rainbow#pairs = [['(', ')'], ['[', ']'],['{','}']]
    " List of colors that you do not want. ANSI code or #RRGGBB
    let g:rainbow#blacklist = [233, 234]
    call s:add('majutsushi/tagbar')
    let g:tagbar_width=30
    let g:tagbar_left = 1
    let g:NERDTreeWinPos='right'
    let g:NERDTreeWinSize=31
    let g:NERDTreeChDirMode=1
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    "noremap <silent> <F3> :NERDTreeToggle<CR>
    noremap <silent> <F3> :VimFiler<CR>
    autocmd FileType nerdtree nnoremap <silent><Space> :call OpenOrCloseNERDTree()<cr>
    noremap <silent> <F2> :TagbarToggle<CR>
    function! OpenOrCloseNERDTree()
        exec "normal A"
    endfunction
    "}}}

    call s:add('wsdjeg/MarkDown.pl')
    call s:add('benjifisher/matchit.zip')
    call s:add('tomasr/molokai')
    call s:add('simnalamburt/vim-mundo')
    nnoremap <silent> <F7> :MundoToggle<CR>
    "call s:add('nerdtree-ack')
    call s:add('L9')
    call s:add('TaskList.vim')
    map <unique> <Leader>td <Plug>TaskList
    call s:add('ianva/vim-youdao-translater')
    vnoremap <silent> <C-l> <Esc>:Ydv<CR>
    nnoremap <silent> <C-l> <Esc>:Ydc<CR>
    noremap <leader>yd :Yde<CR>
    call s:add('elixir-lang/vim-elixir')
    call s:add('tyru/open-browser.vim')
    call s:add('junegunn/fzf')
    nnoremap <Leader>fz :FZF<CR>
    call s:add('junegunn/gv.vim')
    if s:tap('open-brower.vim')
        call s:defind_hooks('open-brower.vim')
    endif
    call s:end()
endif
