_sfig(x...; k...) = isdefined(ProjAssistant, :ImgTools) ? 
    ImgTools.sfig(x...; k...) : error("You must 'import Plots'")
_sgif(x...; k...) = isdefined(ProjAssistant, :ImgTools) ? 
    ImgTools.sgif(x...; k...) : error("You must 'import Plots'")