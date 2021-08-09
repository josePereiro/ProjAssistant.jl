

function gen_sub_proj(currmod::Module, parentmod = parentmodule(currmod))

    # ---------------------------------------------------------------------
    # Check parenthood
    !_is_proj(parentmod) && error("Parent module ($(parentmod)) is not a project.")

    # ---------------------------------------------------------------------
    # Check symbols
    _check_symbols(currmod, 
        [
            :_PROJ_ASSIST_PARENT_PROJ, 
            :_PROJ_ASSIST_TOP_PROJ
        ]
    )

    # ---------------------------------------------------------------------
    # top funs
    @eval currmod begin
        const _PROJ_ASSIST_TOP_PROJ = $(topproj)($(parentmod))
        const _PROJ_ASSIST_PARENT_PROJ = $(parentmod)
    end
    
end

# ---------------------------------------------------------------------
macro gen_sub_proj()
    quote $(gen_sub_proj)(@__MODULE__) end
end

macro gen_sub_proj(dirkw)
    # get dir
    k, parent = dirkw.args
    validarg = Meta.isexpr(dirkw, :(=)) 
    validarg &= (k == :parent) && (parent isa Symbol)
    !validarg && error("An expression `parent=mod::Module` is expected, got ", dirkw)
    
    quote $(gen_sub_proj)(@__MODULE__, $(esc(parent))) end
end

