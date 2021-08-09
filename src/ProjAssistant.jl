module ProjAssistant

    import DrWatson
    import DrWatson: quickactivate, @quickactivate
    import Logging
    import Logging: SimpleLogger, global_logger, with_logger
    import Serialization: serialize, deserialize
    import FileIO
    import Requires: @require
    
    using Base.Threads
    using DataFileNames

    include("utils.jl")
    include("_io_print.jl")
    include("io_global_conf.jl")
    include("_save_load.jl")
    include("scache_lcache.jl")
    include("sdat_ldat.jl")
    include("group_files.jl")
    include("walkdown.jl")
    include("gen_sub_proj.jl")
    include("gen_top_proj.jl")
    include("create_proj_dirs.jl")
    include("sfig_sgif.jl")
    include("sglob_lglob_macros_ex.jl")
    include("sglob_lglob.jl")
    include("proj_functions.jl")

    export dfname, parse_dfname
    export parentproj, topproj, istop_proj
    export projdir, projname
    export devdir, datdir, srcdir, plotsdir, scriptsdir, paperdir
    export cachedir, procdir, rawdir
    export lsdevdir, lsdatdir, lssrcdir, lsplotsdir, lsscriptsdir, 
           lspapersdir, lsprocdir, lsrawdir, lscachedir
    export sdat, sprocdat, srawdat, sfig, sgif
    export ldat, lprocdat, lrawdat
    export cfname, is_cfname, scache, lcache, delcache
    export globfile, sglob, lglob, delglob, @lglob, @sglob

    function __init__()
        _init_globals()

        @require Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80" begin
            import ImgTools
        end
    end

end
