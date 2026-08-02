//terminal
isNil{params["_b"];
private _selections = ((selectionNames _b)select{ "vn_radio" in _x })#0;

_sel = _selections;
_selPos = selectionPosition [ _b , _sel , 1 , true ];
_selPosCorrected = [ _selPos#0 , _selPos#1 , (_selPos#2)+0.55 ];

[_b,"song"]call PFL_Snd;

}