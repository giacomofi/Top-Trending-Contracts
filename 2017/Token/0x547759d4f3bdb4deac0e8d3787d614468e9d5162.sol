['pragma solidity ^ 0.4.15;\n', '\n', '\n', '/**\n', '*contract name : tokenRecipient\n', '*/\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', '\n', '/**\n', '*contract name : GodzStartupBasicInformation\n', '*purpose : be the smart contract for the erc20 tokenof the startup\n', '*goal : to achieve to be the smart contract that the startup use for his stokcs\n', '*/\n', 'contract GodzStartupBasicInformation {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    uint256 public amount;\n', '    uint256 public reward; /*reward offered for the voters*/\n', '    address public owner;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    function GodzStartupBasicInformation(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol,\n', '        uint256 _amount,\n', '        uint256 _reward, /*reward offered for the voters*/\n', '        address _GodzSwapTokens /*address of the smart contract token swap*/\n', '    ) {\n', '        owner = tx.origin; /*becasuse the contract creation is controlled by the smart contract controller we use tx.origin*/\n', '        balanceOf[owner] = initialSupply;\n', '\n', '        totalSupply = initialSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals = decimalUnits;\n', '\n', '        amount = _amount; /*amount of the erc20 token*/\n', '        reward = _reward; /*reward offered for the voters*/\n', '\n', '        allowance[owner][_GodzSwapTokens] = initialSupply; /*here will allow the tokens transfer to the smart contract swap token*/\n', '    }\n', '\n', '     /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) revert();                               /* Prevent transfer to 0x0 address. Use burn() instead*/\n', '        if (balanceOf[msg.sender] < _value) revert();           /* Check if the sender has enough*/\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); /* Check for overflows*/\n', '        balanceOf[msg.sender] -= _value;                        /* Subtract from the sender*/\n', '        balanceOf[_to] += _value;                               /* Add the same to the recipient*/\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /* A contract attempts to get the coins but transfer from the origin*/\n', '    function transferFromOrigin(address _to, uint256 _value)  returns (bool success) {\n', '        address origin = tx.origin;\n', '        if (origin == 0x0) revert();\n', '        if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/\n', '        if (balanceOf[origin] < _value) revert();                /* Check if the sender has enough*/\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/\n', '        balanceOf[origin] -= _value;                             /* Subtract from the sender*/\n', '        balanceOf[_to] += _value;                                /* Add the same to the recipient*/\n', '        return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/\n', '        if (balanceOf[_from] < _value) revert();                 /* Check if the sender has enough*/\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/\n', '        if (_value > allowance[_from][msg.sender]) revert();     /* Check allowance*/\n', '        balanceOf[_from] -= _value;                              /* Subtract from the sender*/\n', '        balanceOf[_to] += _value;                                /* Add the same to the recipient*/\n', '        allowance[_from][msg.sender] -= _value;\n', '        return true;\n', '    }\n', '}']