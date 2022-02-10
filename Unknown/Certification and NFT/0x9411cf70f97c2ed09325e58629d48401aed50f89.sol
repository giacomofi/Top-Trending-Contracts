['pragma solidity ^0.4.11;\n', 'contract WhiteList {\n', '    string public constant VERSION = "0.1.1";\n', '\n', '    mapping(address=>bool) public contains;\n', '    uint public chunkNr = 0;\n', '    uint public recordNr=0;\n', '    uint public controlSum = 0;\n', '    bool public isSetupMode = true;\n', '    address admin = msg.sender;\n', '\n', '    //adds next address package to the internal white list.\n', '    //call valid only in setup mode.\n', '    function addPack(address[] addrs, uint16 _chunkNr)\n', '    setupOnly\n', '    adminOnly\n', '    external {\n', '        require ( chunkNr++ == _chunkNr);\n', '        for(uint16 i=0; i<addrs.length; ++i){\n', '            contains[addrs[i]] = true;\n', '            controlSum += uint160(addrs[i]);\n', '        }\n', '        recordNr += addrs.length;\n', '    }\n', '\n', '    //disable setup mode\n', '    function start()\n', '    adminOnly\n', '    public {\n', '        isSetupMode = false;\n', '    }\n', '\n', '    modifier setupOnly {\n', '        if (!isSetupMode) throw;\n', '        _;\n', '    }\n', '\n', '    modifier adminOnly {\n', '        if (msg.sender != admin) throw;\n', '        _;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', 'contract WhiteList {\n', '    string public constant VERSION = "0.1.1";\n', '\n', '    mapping(address=>bool) public contains;\n', '    uint public chunkNr = 0;\n', '    uint public recordNr=0;\n', '    uint public controlSum = 0;\n', '    bool public isSetupMode = true;\n', '    address admin = msg.sender;\n', '\n', '    //adds next address package to the internal white list.\n', '    //call valid only in setup mode.\n', '    function addPack(address[] addrs, uint16 _chunkNr)\n', '    setupOnly\n', '    adminOnly\n', '    external {\n', '        require ( chunkNr++ == _chunkNr);\n', '        for(uint16 i=0; i<addrs.length; ++i){\n', '            contains[addrs[i]] = true;\n', '            controlSum += uint160(addrs[i]);\n', '        }\n', '        recordNr += addrs.length;\n', '    }\n', '\n', '    //disable setup mode\n', '    function start()\n', '    adminOnly\n', '    public {\n', '        isSetupMode = false;\n', '    }\n', '\n', '    modifier setupOnly {\n', '        if (!isSetupMode) throw;\n', '        _;\n', '    }\n', '\n', '    modifier adminOnly {\n', '        if (msg.sender != admin) throw;\n', '        _;\n', '    }\n', '}']
