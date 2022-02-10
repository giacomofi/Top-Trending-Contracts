['pragma solidity ^0.4.8;\n', '\n', '//ERC20 Compliant\n', 'contract SPARCPresale {    \n', '    uint256 public maxEther     = 1000 ether;\n', '    uint256 public etherRaised  = 0;\n', '    \n', '    address public SPARCAddress;\n', '    address public beneficiary;\n', '    \n', '    bool    public funding      = false;\n', '    \n', '    address public owner;\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', ' \n', '    function SPARCPresale() {\n', '        owner           = msg.sender;\n', '        beneficiary     = msg.sender;\n', '    }\n', '    \n', '    function withdrawEther(uint256 amount) onlyOwner {\n', '        require(amount <= this.balance);\n', '        \n', '        if(!beneficiary.send(this.balance)){\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function setSPARCAddress(address _SPARCAddress) onlyOwner {\n', '        SPARCAddress    = _SPARCAddress;\n', '    }\n', '    \n', '    function startSale() onlyOwner {\n', '        funding = true;\n', '    }\n', '    \n', '    // Ether transfer to this contact is only available untill the presale limit is reached.\n', '    \n', '    // By transfering ether to this contract you are agreeing to these terms of the contract:\n', '    // - You are not in anyway forbidden from doing business with Canadian businesses or citizens.\n', '    // - Your funds are not proceeeds of illegal activity.\n', '    // - Howey Disclaimer:\n', '    //   - SPARCs do not represent equity or share in the foundation.\n', '    //   - SPARCs are products of the foundation.\n', '    //   - There is no expectation of profit from your purchase of SPARCs.\n', '    //   - SPARCs are for the purpose of reserving future network power.\n', '    function () payable {\n', '        assert(funding);\n', '        assert(etherRaised < maxEther);\n', '        require(msg.value != 0);\n', '        require(etherRaised + msg.value <= maxEther);\n', '        \n', '        etherRaised  += msg.value;\n', '        \n', '        if(!SPARCToken(SPARCAddress).create(msg.sender, msg.value * 20000)){\n', '            throw;\n', '        }\n', '    }\n', '}\n', '\n', '/// SPARCToken interface\n', 'contract SPARCToken {\n', '    function create(address to, uint256 amount) returns (bool);\n', '}']
['pragma solidity ^0.4.8;\n', '\n', '//ERC20 Compliant\n', 'contract SPARCPresale {    \n', '    uint256 public maxEther     = 1000 ether;\n', '    uint256 public etherRaised  = 0;\n', '    \n', '    address public SPARCAddress;\n', '    address public beneficiary;\n', '    \n', '    bool    public funding      = false;\n', '    \n', '    address public owner;\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', ' \n', '    function SPARCPresale() {\n', '        owner           = msg.sender;\n', '        beneficiary     = msg.sender;\n', '    }\n', '    \n', '    function withdrawEther(uint256 amount) onlyOwner {\n', '        require(amount <= this.balance);\n', '        \n', '        if(!beneficiary.send(this.balance)){\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function setSPARCAddress(address _SPARCAddress) onlyOwner {\n', '        SPARCAddress    = _SPARCAddress;\n', '    }\n', '    \n', '    function startSale() onlyOwner {\n', '        funding = true;\n', '    }\n', '    \n', '    // Ether transfer to this contact is only available untill the presale limit is reached.\n', '    \n', '    // By transfering ether to this contract you are agreeing to these terms of the contract:\n', '    // - You are not in anyway forbidden from doing business with Canadian businesses or citizens.\n', '    // - Your funds are not proceeeds of illegal activity.\n', '    // - Howey Disclaimer:\n', '    //   - SPARCs do not represent equity or share in the foundation.\n', '    //   - SPARCs are products of the foundation.\n', '    //   - There is no expectation of profit from your purchase of SPARCs.\n', '    //   - SPARCs are for the purpose of reserving future network power.\n', '    function () payable {\n', '        assert(funding);\n', '        assert(etherRaised < maxEther);\n', '        require(msg.value != 0);\n', '        require(etherRaised + msg.value <= maxEther);\n', '        \n', '        etherRaised  += msg.value;\n', '        \n', '        if(!SPARCToken(SPARCAddress).create(msg.sender, msg.value * 20000)){\n', '            throw;\n', '        }\n', '    }\n', '}\n', '\n', '/// SPARCToken interface\n', 'contract SPARCToken {\n', '    function create(address to, uint256 amount) returns (bool);\n', '}']
