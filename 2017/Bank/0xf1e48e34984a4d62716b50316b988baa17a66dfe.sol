['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library TiposCompartidos {\n', '    enum TipoPremio {none,free,x2,x3,x5, surprise }\n', '\n', '    struct Celda {\n', '        address creador;\n', '        uint polenPositivos;\n', '        uint polenNegativos;\n', '        uint256 fechaCreacion;\n', '        uint primeraPosicion;\n', '        uint segundaPosicion;\n', '        uint terceraPosicion;\n', '        uint cuartaPosicion;\n', '        uint quintaPosicion;\n', '        uint sextaPosicion;\n', '        TipoPremio tipo;\n', '        bool premio;\n', '    }\n', '    \n', '}\n', '\n', 'contract BeeGame is owned {\n', '    \n', '    uint256 internal sellPrice;\n', '    uint256 internal buyPrice;\n', '    uint internal numeroCeldas;\n', '    string internal name;\n', '    string internal symbol;\n', '    uint8 internal decimals;\n', '    uint internal numeroUsuarios;\n', '    uint fechaTax;\n', '\n', '    mapping (address => uint) balanceOf;\n', '\n', '    address[] indiceUsuarios;\n', '    \n', '    mapping (uint256 => TiposCompartidos.Celda) celdas;\n', '    \n', '    uint256[] indiceCeldas;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event TransferKO(address indexed from, address indexed to, uint256 value);\n', '    \n', '    function BeeGame (\n', '        uint256 initialSupply,\n', '        uint256 newSellPrice,\n', '        uint256 newBuyPrice,\n', '        uint _fechaTax) {\n', '        fechaTax = _fechaTax;\n', '        balanceOf[owner] = initialSupply;\n', '        setPrices(newSellPrice,newBuyPrice);\n', '        numeroCeldas = 0;\n', '        name = "Beether";\n', '        symbol = "beeth"; \n', '        decimals = 2;\n', '        TiposCompartidos.Celda memory celda = TiposCompartidos.Celda({\n', '            creador:msg.sender,\n', '            polenPositivos : 0, \n', '            polenNegativos : 3,\n', '            fechaCreacion: 1509302402021,\n', '            primeraPosicion : 0,\n', '            segundaPosicion : 0,\n', '            terceraPosicion : 0,\n', '            cuartaPosicion : 0,\n', '            quintaPosicion : 0,\n', '            sextaPosicion : 0,\n', '            tipo:TiposCompartidos.TipoPremio.none,\n', '            premio:false\n', '        });\n', '        indiceCeldas.push(1509302402021);\n', '        numeroCeldas = numeroCeldas + 1;\n', '        celdas[1509302402021] = celda;\n', '    }\n', '\n', '    function buy() payable returns (uint amount) {\n', '        amount = msg.value / buyPrice;         \n', '        require(balanceOf[owner] >= amount); \n', '        _transfer(owner, msg.sender, amount);\n', '        incluirUsuario(msg.sender);\n', '        Transfer(owner, msg.sender, amount); \n', '        return amount;                         \n', '    }\n', '\n', '    function incluirUsuario(address usuario){\n', '        bool encontrado = false;\n', '        for (uint i = 0; i < numeroUsuarios; i++) {\n', '            address usuarioT = indiceUsuarios[i];\n', '            if (usuarioT == usuario){\n', '                encontrado = true;\n', '            }\n', '        }\n', '        if(!encontrado){\n', '            indiceUsuarios.push(usuario);\n', '            numeroUsuarios++;\n', '        }\n', '    }\n', '\n', '    function cobrarImpuesto(uint _fechaTax) onlyOwner {\n', '        for (uint i = 0; i < numeroUsuarios; i++) {\n', '            address usuario = indiceUsuarios[i];\n', '            if (balanceOf[usuario] > 0){\n', '                _transfer(usuario, owner, 1);\n', '            }\n', '        }\n', '        fechaTax = _fechaTax;\n', '    }\n', '\n', '    function crearCelda(uint _polenes, uint256 _fechaCreacion, uint posicion, uint _celdaPadre, uint _celdaAbuelo, TiposCompartidos.TipoPremio tipo) {\n', '        require(balanceOf[msg.sender]>=3);\n', '        require(_polenes == 3);\n', '        require(_celdaPadre != 0);\n', '        require((posicion >= 0 && posicion < 7) || (posicion == 0 && msg.sender == owner));\n', '        require(((tipo == TiposCompartidos.TipoPremio.free || tipo == TiposCompartidos.TipoPremio.x2 || tipo == TiposCompartidos.TipoPremio.x3 || tipo == TiposCompartidos.TipoPremio.x5 || tipo == TiposCompartidos.TipoPremio.surprise) && msg.sender == owner) || tipo == TiposCompartidos.TipoPremio.none);\n', '        TiposCompartidos.Celda memory celdaPadre = celdas[_celdaPadre];\n', '        require(\n', '            ((posicion == 1 && celdaPadre.primeraPosicion == 0) || celdas[celdaPadre.primeraPosicion].tipo != TiposCompartidos.TipoPremio.none ) || \n', '            ((posicion == 2 && celdaPadre.segundaPosicion == 0) || celdas[celdaPadre.segundaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || \n', '            ((posicion == 3 && celdaPadre.terceraPosicion == 0) || celdas[celdaPadre.terceraPosicion].tipo != TiposCompartidos.TipoPremio.none ) || \n', '            ((posicion == 4 && celdaPadre.cuartaPosicion == 0)  || celdas[celdaPadre.cuartaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || \n', '            ((posicion == 5 && celdaPadre.quintaPosicion == 0)  || celdas[celdaPadre.quintaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || \n', '            ((posicion == 6 && celdaPadre.sextaPosicion == 0) || celdas[celdaPadre.sextaPosicion].tipo != TiposCompartidos.TipoPremio.none )\n', '        );\n', '        TiposCompartidos.Celda memory celda;\n', '        TiposCompartidos.TipoPremio tipoPremio;\n', '        if (celdas[_fechaCreacion].fechaCreacion == _fechaCreacion) {\n', '            celda = celdas[_fechaCreacion];\n', '            celda.creador = msg.sender;\n', '            celda.premio = false;\n', '            tipoPremio = celda.tipo;\n', '            celda.tipo = TiposCompartidos.TipoPremio.none;\n', '        } else {\n', '            if (msg.sender != owner) {\n', '                celda = TiposCompartidos.Celda({\n', '                    creador:msg.sender,\n', '                    polenPositivos : 0, \n', '                    polenNegativos : _polenes,\n', '                    fechaCreacion: _fechaCreacion,\n', '                    primeraPosicion : 0,\n', '                    segundaPosicion : 0,\n', '                    terceraPosicion : 0,\n', '                    cuartaPosicion : 0,\n', '                    quintaPosicion : 0,\n', '                    sextaPosicion : 0,\n', '                    tipo:tipo,\n', '                    premio:false\n', '                });\n', '            }else {\n', '                celda = TiposCompartidos.Celda({\n', '                    creador:msg.sender,\n', '                    polenPositivos : 0, \n', '                    polenNegativos : _polenes,\n', '                    fechaCreacion: _fechaCreacion,\n', '                    primeraPosicion : 0,\n', '                    segundaPosicion : 0,\n', '                    terceraPosicion : 0,\n', '                    cuartaPosicion : 0,\n', '                    quintaPosicion : 0,\n', '                    sextaPosicion : 0,\n', '                    tipo:tipo,\n', '                    premio:true\n', '                });\n', '            }\n', '            indiceCeldas.push(_fechaCreacion);\n', '            numeroCeldas = numeroCeldas + 1;\n', '        }\n', '        celdas[_fechaCreacion] = celda;\n', '        TiposCompartidos.Celda memory celdaAbuelo = celdas[_celdaAbuelo];\n', '        uint multiplicador = 1;\n', '        address repartidor = msg.sender;\n', '        if (tipoPremio == TiposCompartidos.TipoPremio.x2 && !celda.premio) {\n', '            multiplicador = 2;\n', '            repartidor = owner;\n', '        } else if (tipoPremio == TiposCompartidos.TipoPremio.x3 && !celda.premio) {\n', '            multiplicador = 3;\n', '            repartidor = owner;\n', '        } else if (tipoPremio == TiposCompartidos.TipoPremio.x5 && !celda.premio) {\n', '            multiplicador = 5;\n', '            repartidor = owner;\n', '        }  else if (tipoPremio == TiposCompartidos.TipoPremio.free && !celda.premio) {\n', '            repartidor = owner;\n', '        }\n', '        if (posicion == 1 && celdaPadre.primeraPosicion == 0) {\n', '            celdaPadre.primeraPosicion = _fechaCreacion;   \n', '        }else if (posicion == 2 && celdaPadre.segundaPosicion == 0 ) {\n', '            celdaPadre.segundaPosicion = _fechaCreacion;\n', '        }else if (posicion == 3 && celdaPadre.terceraPosicion == 0) {\n', '            celdaPadre.terceraPosicion = _fechaCreacion;\n', '        }else if (posicion == 4 && celdaPadre.cuartaPosicion == 0) {\n', '            celdaPadre.cuartaPosicion = _fechaCreacion;\n', '        }else if (posicion == 5 && celdaPadre.quintaPosicion == 0) {\n', '            celdaPadre.quintaPosicion = _fechaCreacion;\n', '        }else if (posicion == 6 && celdaPadre.sextaPosicion == 0) {\n', '            celdaPadre.sextaPosicion = _fechaCreacion;\n', '        }\n', '        if (_celdaAbuelo != 0 && !celda.premio) {\n', '            _transfer(repartidor,celdaPadre.creador,2 * multiplicador);\n', '            celdaPadre.polenPositivos = celdaPadre.polenPositivos + (2 * multiplicador);\n', '            celdaAbuelo.polenPositivos = celdaAbuelo.polenPositivos + (1 * multiplicador);\n', '            _transfer(repartidor,celdaAbuelo.creador,1 * multiplicador);\n', '            celdas[celdaAbuelo.fechaCreacion] = celdaAbuelo;\n', '        }else if (!celda.premio) {\n', '            _transfer(repartidor,celdaPadre.creador,3 * multiplicador);\n', '            celdaPadre.polenPositivos = celdaPadre.polenPositivos + ( 3 * multiplicador);\n', '        }\n', '        celdas[celdaPadre.fechaCreacion] = celdaPadre;\n', '    }\n', '\n', '    function getCelda(uint index) returns (address creador, uint polenPositivos, uint polenNegativos, uint fechaCreacion, \n', '                                            uint primeraPosicion, uint segundaPosicion, uint terceraPosicion,\n', '                                            uint cuartaPosicion, uint quintaPosicion, uint sextaPosicion, TiposCompartidos.TipoPremio tipo, bool premio) {\n', '        uint256 indexA = indiceCeldas[index];\n', '        TiposCompartidos.Celda memory  celda = celdas[indexA];\n', '        return (celda.creador,celda.polenPositivos,celda.polenNegativos,celda.fechaCreacion,\n', '        celda.primeraPosicion, celda.segundaPosicion, celda.terceraPosicion, celda.cuartaPosicion, \n', '        celda.quintaPosicion, celda.sextaPosicion, celda.tipo, celda.premio);\n', '    }\n', '\n', '    function getBalance(address addr) returns(uint) {\n', '\t\treturn balanceOf[addr];\n', '\t}\n', '\n', '    function getFechaTax() returns(uint) {\n', '        return fechaTax;\n', '    }\n', '\n', '    function getNumeroCeldas() returns(uint) {\n', '        return numeroCeldas;\n', '    }\n', '\n', '    function getOwner() returns(address) {\n', '        return owner;\n', '    }\n', '\n', '    function getRevenue(uint amount) onlyOwner {\n', '        owner.transfer(amount);\n', '    }\n', '\n', '    function sell(uint amount){\n', '        require(balanceOf[msg.sender] >= amount);         \n', '        _transfer(msg.sender, owner, amount);\n', '        uint revenue = amount * sellPrice;\n', '        if (msg.sender.send (revenue)) {                \n', '            Transfer(msg.sender, owner, revenue);  \n', '        }else {\n', '            _transfer(owner, msg.sender, amount);\n', '            TransferKO(msg.sender, this, revenue);\n', '        }                                   \n', '    }\n', '\n', '    function setFechaTax(uint _fechaTax) onlyOwner {\n', '        fechaTax = _fechaTax;\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice * 1 finney;\n', '        buyPrice = newBuyPrice * 1 finney;\n', '    }\n', '\n', '    function transfer(address _to, uint _value){\n', '        _transfer(msg.sender, _to, _value);\n', '        incluirUsuario(_to);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balanceOf[_from] >= _value);                // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        balanceOf[_from] = balanceOf[_from] - _value;                         \n', '        balanceOf[_to] = balanceOf[_to] + _value;                           \n', '        Transfer(_from, _to, _value);\n', '    }\n', '}']