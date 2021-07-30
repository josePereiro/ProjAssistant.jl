# Based in DrWatson

const DATA_KEY = :dat
const GIT_COMMIT_KEY = :gitcommit
const GIT_PATCH_KEY = :gitpatch
const DIRTY_SUFFIX = "_dirty"
const SHORT_HASH_LENGTH = 7
const ERROR_LOGGER = SimpleLogger(stdout, Logging.Error)

# ------------------------------------------------------------------
function ldat(dfargs...; 
        print_fun::Function = global_conf(:PRINT_FUN), 
        headline::AbstractString = "DATA LOADED",
        verbose::Bool = global_conf(:VERBOSE),
        load_fun::Function = global_conf(:LOAD_FUN), 
        mkdir::Bool = global_conf(:MK_DIR)
    )

    datfile = dfname(dfargs...)
    mkdir && mkpath(dirname(datfile))
    file_dat = load_fun(datfile)
    dat = file_dat[DATA_KEY]
    commit_hash = get(file_dat, GIT_COMMIT_KEY, "none")
    verbose &&  _io_print(
        print_fun, headline, dat, datfile, 
        "\ncommit: ", _cut_hash(commit_hash)
    )
    return dat
end
function ldat(f::Function, dfargs...; kwargs...)
    datfile = dfname(dfargs...)
    !isfile(datfile) && sdat(f(), datfile; kwargs...)
    ldat(datfile; kwargs...)
end

# ------------------------------------------------------------------
function sdat(f::Function, dfargs...; 
        headline::AbstractString = "DATA SAVED",
        verbose::Bool = global_conf(:VERBOSE), 
        print_fun::Function = global_conf(:PRINT_FUN), 
        addtag::Bool = global_conf(:ADD_TAG),
        savefun::Function = global_conf(:SAVE_FUN),
        mkdir::Bool = global_conf(:MK_DIR)
    )
    dat = f()
    datfile = dfname(dfargs...)
    mkdir && mkpath(dirname(datfile))

    L = verbose ? global_logger() : ERROR_LOGGER
    with_logger(L) do
        dict = Dict(DATA_KEY => dat)
        tagdat = addtag ? DrWatson.tag!(dict) : dict
        savefun(datfile, tagdat)
        verbose && verbose && _io_print(
            print_fun, headline, dat, datfile, 
            "\ncommit: ", get(tagdat, :gitcommit, "none")
        )
        return datfile
    end
end
sdat(dat, dfargs...; kwargs...) = sdat(() -> dat, dfargs...; kwargs...) 

# ------------------------------------------------------------------
function dhash(datfile, l = SHORT_HASH_LENGTH) 
    hash = get(_load(datfile), GIT_COMMIT_KEY, "")
    _cut_hash(hash, l)
end

function _cut_hash(commit_hash, l = SHORT_HASH_LENGTH)
    short_hash = first(commit_hash, l)
    endswith(commit_hash, DIRTY_SUFFIX) ? string(short_hash, DIRTY_SUFFIX) : short_hash
end

lgitpatth(args...) = get(ldat(args...), GIT_PATCH_KEY, "")
