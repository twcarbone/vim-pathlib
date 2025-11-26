vim9script

export class Path
    ## Public

    ## Protected

    var _path: string
    var _parts: list<string>

    ## Constructor

    def new(path: string)
        this._path = path
        this._parts = path->split('/')
    enddef

    ## Builtin

    def empty(): bool
        return this._path == ''
    enddef

    def len(): number
        return len(this._path)
    enddef

    def string(): string
        return this._path
    enddef

    ## Object methods

    def Name(): string
        return this._path->fnamemodify(":t")
    enddef

    def Parts(): list<string>
        return this._parts
    enddef
endclass

defcompile Path
