['pragma solidity ^0.4.23;\n', '//pragma experimental ABIEncoderV2;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '//-------------------------------------------------------------------------------------\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public view returns (uint);\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract ERC223 is ERC20 {\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);\n', '}\n', '\n', '/*\n', 'Base class contracts willing to accept ERC223 token transfers must conform to.\n', '\n', 'Sender: msg.sender to the token contract, the address originating the token transfer.\n', '          - For user originated transfers sender will be equal to tx.origin\n', '          - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.\n', 'Origin: the origin address from whose balance the tokens are sent\n', '          - For transfer(), origin = msg.sender\n', '          - For transferFrom() origin = _from to token contract\n', 'Value is the amount of tokens sent\n', 'Data is arbitrary data sent with the token transfer. Simulates ether tx.data\n', '\n', 'From, origin and value shouldn&#39;t be trusted unless the token contract is trusted.\n', 'If sender == tx.origin, it is safe to trust it regardless of the token.\n', '*/\n', '\n', 'contract ERC223Receiver {\n', '    function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool ok);\n', '}\n', '\n', 'contract Standard223Receiver is ERC223Receiver {\n', '    function supportsToken(address token) public view returns (bool);\n', '}\n', '\n', '\n', '//-------------------------------------------------------------------------------------\n', '//Implementation\n', '\n', '//contract WeSingCoin223Token_8 is ERC20, ERC223, Standard223Receiver, SafeMath {\n', 'contract LiveBox223Token is ERC20, ERC223, Standard223Receiver, SafeMath {\n', '\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '  \n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show.\n', '    string public symbol;                 //An identifier: eg SBX\n', '\n', '    address /*public*/ contrInitiator;\n', '    address /*public*/ thisContract;\n', '    bool /*public*/ isTokenSupport;\n', '  \n', '    mapping(address => bool) isSendingLocked;\n', '    bool isAllTransfersLocked;\n', '  \n', '    uint oneTransferLimit;\n', '    uint oneDayTransferLimit;\n', ' \n', '\n', '    struct TransferInfo {\n', '        //address sender;    //maybe use in the future\n', '        //address from;      //no need because all this is kept in transferInfo[_from]\n', '        //address to;        //maybe use in the future\n', '        uint256 value;\n', '        uint time;\n', '    }\n', '\n', '    struct TransferInfos {\n', '        mapping (uint => TransferInfo) ti;\n', '        uint tc;\n', '    }\n', '  \n', '    mapping (address => TransferInfos) transferInfo;\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from ExampleToken\n', '\n', '    constructor(/*uint initialBalance*/) public {\n', '    \n', '        decimals    = 6;                                // Amount of decimals for display purposes\n', '//      name        = "WeSingCoin";                     // Set the name for display purposes\n', '//      symbol      = &#39;WSC&#39;;                            // Set the symbol for display purposes\n', '        name        = "LiveBoxCoin";                     // Set the name for display purposes\n', '        symbol      = &#39;LBC&#39;;                            // Set the symbol for display purposes\n', '\n', '        uint initialBalance  = (10 ** uint256(decimals)) * 5000*1000*1000;\n', '    \n', '        balances[msg.sender] = initialBalance;\n', '        totalSupply = initialBalance;\n', '    \n', '        contrInitiator = msg.sender;\n', '        thisContract = this;\n', '        isTokenSupport = false;\n', '    \n', '        isAllTransfersLocked = true;\n', '    \n', '        oneTransferLimit    = (10 ** uint256(decimals)) * 10*1000*1000;\n', '        oneDayTransferLimit = (10 ** uint256(decimals)) * 50*1000*1000;\n', '\n', '    // Ideally call token fallback here too\n', '    }\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from StandardToken\n', '\n', '    function super_transfer(address _to, uint _value) /*public*/ internal returns (bool success) {\n', '\n', '        require(!isSendingLocked[msg.sender]);\n', '        require(_value <= oneTransferLimit);\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        if(msg.sender == contrInitiator) {\n', '            //no restricton\n', '        } else {\n', '            require(!isAllTransfersLocked);  \n', '            require(safeAdd(getLast24hSendingValue(msg.sender), _value) <= oneDayTransferLimit);\n', '        }\n', '\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '    \n', '        uint tc=transferInfo[msg.sender].tc;\n', '        transferInfo[msg.sender].ti[tc].value = _value;\n', '        transferInfo[msg.sender].ti[tc].time = now;\n', '        transferInfo[msg.sender].tc = safeAdd(transferInfo[msg.sender].tc, 1);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function super_transferFrom(address _from, address _to, uint _value) /*public*/ internal returns (bool success) {\n', '        \n', '        require(!isSendingLocked[_from]);\n', '        require(_value <= oneTransferLimit);\n', '        require(balances[_from] >= _value);\n', '\n', '        if(msg.sender == contrInitiator && _from == thisContract) {\n', '            // no restriction\n', '        } else {\n', '            require(!isAllTransfersLocked);  \n', '            require(safeAdd(getLast24hSendingValue(_from), _value) <= oneDayTransferLimit);\n', '            uint allowance = allowed[_from][msg.sender];\n', '            require(allowance >= _value);\n', '            allowed[_from][msg.sender] = safeSub(allowance, _value);\n', '        }\n', '\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '    \n', '        uint tc=transferInfo[_from].tc;\n', '        transferInfo[_from].ti[tc].value = _value;\n', '        transferInfo[_from].ti[tc].time = now;\n', '        transferInfo[_from].tc = safeAdd(transferInfo[_from].tc, 1);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '  \n', '//-------------------------------------------------------------------------------------\n', '//from Standard223Token\n', '\n', '    //function that is called when a user or another contract wants to transfer funds\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '        //filtering if the target is a contract with bytecode inside it\n', '        if (!super_transfer(_to, _value)) assert(false); // do a normal token transfer\n', '        if (isContract(_to)) {\n', '            if(!contractFallback(msg.sender, _to, _value, _data)) assert(false);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {\n', '        if (!super_transferFrom(_from, _to, _value)) assert(false); // do a normal token transfer\n', '        if (isContract(_to)) {\n', '            if(!contractFallback(_from, _to, _value, _data)) assert(false);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        return transfer(_to, _value, new bytes(0));\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        return transferFrom(_from, _to, _value, new bytes(0));\n', '    }\n', '\n', '    //function that is called when transaction target is a contract\n', '    function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {\n', '        ERC223Receiver reciever = ERC223Receiver(_to);\n', '        return reciever.tokenFallback(msg.sender, _origin, _value, _data);\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        // retrieve the size of the code on target address, this needs assembly\n', '        uint length;\n', '        assembly { length := extcodesize(_addr) }\n', '        return length > 0;\n', '    }\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from Standard223Receiver\n', '\n', '    Tkn tkn;\n', '\n', '    struct Tkn {\n', '        address addr;\n', '        address sender;\n', '        address origin;\n', '        uint256 value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool ok) {\n', '        if (!supportsToken(msg.sender)) return false;\n', '\n', '        // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.\n', '        tkn = Tkn(msg.sender, _sender, _origin, _value, _data, getSig(_data));\n', '        __isTokenFallback = true;\n', '        if (!address(this).delegatecall(_data)) return false;\n', '\n', '        // avoid doing an overwrite to .token, which would be more expensive\n', '        // makes accessing .tkn values outside tokenPayable functions unsafe\n', '        __isTokenFallback = false;\n', '\n', '        return true;\n', '    }\n', '\n', '    function getSig(bytes _data) private pure returns (bytes4 sig) {\n', '        uint l = _data.length < 4 ? _data.length : 4;\n', '        for (uint i = 0; i < l; i++) {\n', '            sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));\n', '        }\n', '    }\n', '\n', '    bool __isTokenFallback;\n', '\n', '    modifier tokenPayable {\n', '        if (!__isTokenFallback) assert(false);\n', '        _;                                                              //_ is a special character used in modifiers\n', '    }\n', '\n', '    //function supportsToken(address token) public pure returns (bool);  //moved up\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from ExampleReceiver\n', '\n', '/*\n', '//we do not use dedicated function to receive Token in contract associated account\n', '    function foo(\n', '        //uint i\n', '        ) tokenPayable public {\n', '        emit LogTokenPayable(1, tkn.addr, tkn.sender, tkn.value);\n', '    }\n', '*/\n', '    function () tokenPayable public {\n', '        emit LogTokenPayable(0, tkn.addr, tkn.sender, tkn.value);\n', '    }\n', '\n', '      function supportsToken(address token) public view returns (bool) {\n', '        //do not need to to anything with that token address?\n', '        //if (token == 0) { //attila addition\n', '        if (token != thisContract) { //attila addition, support only our own token, not others&#39; token\n', '            return false;\n', '        }\n', '        if(!isTokenSupport) {  //attila addition\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    event LogTokenPayable(uint i, address token, address sender, uint value);\n', '  \n', '//-------------------------------------------------------------------------------------\n', '// My extensions\n', '/*\n', '    function enableTokenSupport(bool _tokenSupport) public returns (bool success) {\n', '        if(msg.sender == contrInitiator) {\n', '            isTokenSupport = _tokenSupport;\n', '            return true;\n', '        } else {\n', '            return false;  \n', '        }\n', '    }\n', '*/\n', '    function setIsAllTransfersLocked(bool _lock) public {\n', '        require(msg.sender == contrInitiator);\n', '        isAllTransfersLocked = _lock;\n', '    }\n', '\n', '    function setIsSendingLocked(address _from, bool _lock) public {\n', '        require(msg.sender == contrInitiator);\n', '        isSendingLocked[_from] = _lock;\n', '    }\n', '\n', '    function getIsAllTransfersLocked() public view returns (bool ok) {\n', '        return isAllTransfersLocked;\n', '    }\n', '\n', '    function getIsSendingLocked(address _from ) public view returns (bool ok) {\n', '        return isSendingLocked[_from];\n', '    }\n', ' \n', '/*  \n', '    function getTransferInfoCount(address _from) public view returns (uint count) {\n', '        return transferInfo[_from].tc;\n', '    }\n', '*/    \n', '/*\n', '    // use experimental feature\n', '    function getTransferInfo(address _from, uint index) public view returns (TransferInfo ti) {\n', '        return transferInfo[_from].ti[index];\n', '    }\n', '*/ \n', '/*\n', '    function getTransferInfoTime(address _from, uint index) public view returns (uint time) {\n', '        return transferInfo[_from].ti[index].time;\n', '    }\n', '*/\n', '/*\n', '    function getTransferInfoValue(address _from, uint index) public view returns (uint value) {\n', '        return transferInfo[_from].ti[index].value;\n', '    }\n', '*/\n', '    function getLast24hSendingValue(address _from) public view returns (uint totVal) {\n', '      \n', '        totVal = 0;  //declared above;\n', '        uint tc = transferInfo[_from].tc;\n', '      \n', '        if(tc > 0) {\n', '            for(uint i = tc-1 ; i >= 0 ; i--) {\n', '//              if(now - transferInfo[_from].ti[i].time < 10 minutes) {\n', '//              if(now - transferInfo[_from].ti[i].time < 1 hours) {\n', '                if(now - transferInfo[_from].ti[i].time < 1 days) {\n', '                    totVal = safeAdd(totVal, transferInfo[_from].ti[i].value );\n', '                } else {\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    \n', '    function airdropIndividual(address[] _recipients, uint256[] _values, uint256 _elemCount, uint _totalValue)  public returns (bool success) {\n', '        \n', '        require(_recipients.length == _elemCount);\n', '        require(_values.length == _elemCount); \n', '        \n', '        uint256 totalValue = 0;\n', '        for(uint i = 0; i< _recipients.length; i++) {\n', '            totalValue = safeAdd(totalValue, _values[i]);\n', '        }\n', '        \n', '        require(totalValue == _totalValue);\n', '        \n', '        for(i = 0; i< _recipients.length; i++) {\n', '            transfer(_recipients[i], _values[i]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.23;\n', '//pragma experimental ABIEncoderV2;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '//-------------------------------------------------------------------------------------\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public view returns (uint);\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract ERC223 is ERC20 {\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);\n', '}\n', '\n', '/*\n', 'Base class contracts willing to accept ERC223 token transfers must conform to.\n', '\n', 'Sender: msg.sender to the token contract, the address originating the token transfer.\n', '          - For user originated transfers sender will be equal to tx.origin\n', '          - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.\n', 'Origin: the origin address from whose balance the tokens are sent\n', '          - For transfer(), origin = msg.sender\n', '          - For transferFrom() origin = _from to token contract\n', 'Value is the amount of tokens sent\n', 'Data is arbitrary data sent with the token transfer. Simulates ether tx.data\n', '\n', "From, origin and value shouldn't be trusted unless the token contract is trusted.\n", 'If sender == tx.origin, it is safe to trust it regardless of the token.\n', '*/\n', '\n', 'contract ERC223Receiver {\n', '    function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool ok);\n', '}\n', '\n', 'contract Standard223Receiver is ERC223Receiver {\n', '    function supportsToken(address token) public view returns (bool);\n', '}\n', '\n', '\n', '//-------------------------------------------------------------------------------------\n', '//Implementation\n', '\n', '//contract WeSingCoin223Token_8 is ERC20, ERC223, Standard223Receiver, SafeMath {\n', 'contract LiveBox223Token is ERC20, ERC223, Standard223Receiver, SafeMath {\n', '\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '  \n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show.\n', '    string public symbol;                 //An identifier: eg SBX\n', '\n', '    address /*public*/ contrInitiator;\n', '    address /*public*/ thisContract;\n', '    bool /*public*/ isTokenSupport;\n', '  \n', '    mapping(address => bool) isSendingLocked;\n', '    bool isAllTransfersLocked;\n', '  \n', '    uint oneTransferLimit;\n', '    uint oneDayTransferLimit;\n', ' \n', '\n', '    struct TransferInfo {\n', '        //address sender;    //maybe use in the future\n', '        //address from;      //no need because all this is kept in transferInfo[_from]\n', '        //address to;        //maybe use in the future\n', '        uint256 value;\n', '        uint time;\n', '    }\n', '\n', '    struct TransferInfos {\n', '        mapping (uint => TransferInfo) ti;\n', '        uint tc;\n', '    }\n', '  \n', '    mapping (address => TransferInfos) transferInfo;\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from ExampleToken\n', '\n', '    constructor(/*uint initialBalance*/) public {\n', '    \n', '        decimals    = 6;                                // Amount of decimals for display purposes\n', '//      name        = "WeSingCoin";                     // Set the name for display purposes\n', "//      symbol      = 'WSC';                            // Set the symbol for display purposes\n", '        name        = "LiveBoxCoin";                     // Set the name for display purposes\n', "        symbol      = 'LBC';                            // Set the symbol for display purposes\n", '\n', '        uint initialBalance  = (10 ** uint256(decimals)) * 5000*1000*1000;\n', '    \n', '        balances[msg.sender] = initialBalance;\n', '        totalSupply = initialBalance;\n', '    \n', '        contrInitiator = msg.sender;\n', '        thisContract = this;\n', '        isTokenSupport = false;\n', '    \n', '        isAllTransfersLocked = true;\n', '    \n', '        oneTransferLimit    = (10 ** uint256(decimals)) * 10*1000*1000;\n', '        oneDayTransferLimit = (10 ** uint256(decimals)) * 50*1000*1000;\n', '\n', '    // Ideally call token fallback here too\n', '    }\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from StandardToken\n', '\n', '    function super_transfer(address _to, uint _value) /*public*/ internal returns (bool success) {\n', '\n', '        require(!isSendingLocked[msg.sender]);\n', '        require(_value <= oneTransferLimit);\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        if(msg.sender == contrInitiator) {\n', '            //no restricton\n', '        } else {\n', '            require(!isAllTransfersLocked);  \n', '            require(safeAdd(getLast24hSendingValue(msg.sender), _value) <= oneDayTransferLimit);\n', '        }\n', '\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '    \n', '        uint tc=transferInfo[msg.sender].tc;\n', '        transferInfo[msg.sender].ti[tc].value = _value;\n', '        transferInfo[msg.sender].ti[tc].time = now;\n', '        transferInfo[msg.sender].tc = safeAdd(transferInfo[msg.sender].tc, 1);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function super_transferFrom(address _from, address _to, uint _value) /*public*/ internal returns (bool success) {\n', '        \n', '        require(!isSendingLocked[_from]);\n', '        require(_value <= oneTransferLimit);\n', '        require(balances[_from] >= _value);\n', '\n', '        if(msg.sender == contrInitiator && _from == thisContract) {\n', '            // no restriction\n', '        } else {\n', '            require(!isAllTransfersLocked);  \n', '            require(safeAdd(getLast24hSendingValue(_from), _value) <= oneDayTransferLimit);\n', '            uint allowance = allowed[_from][msg.sender];\n', '            require(allowance >= _value);\n', '            allowed[_from][msg.sender] = safeSub(allowance, _value);\n', '        }\n', '\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '    \n', '        uint tc=transferInfo[_from].tc;\n', '        transferInfo[_from].ti[tc].value = _value;\n', '        transferInfo[_from].ti[tc].time = now;\n', '        transferInfo[_from].tc = safeAdd(transferInfo[_from].tc, 1);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '  \n', '//-------------------------------------------------------------------------------------\n', '//from Standard223Token\n', '\n', '    //function that is called when a user or another contract wants to transfer funds\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '        //filtering if the target is a contract with bytecode inside it\n', '        if (!super_transfer(_to, _value)) assert(false); // do a normal token transfer\n', '        if (isContract(_to)) {\n', '            if(!contractFallback(msg.sender, _to, _value, _data)) assert(false);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {\n', '        if (!super_transferFrom(_from, _to, _value)) assert(false); // do a normal token transfer\n', '        if (isContract(_to)) {\n', '            if(!contractFallback(_from, _to, _value, _data)) assert(false);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        return transfer(_to, _value, new bytes(0));\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        return transferFrom(_from, _to, _value, new bytes(0));\n', '    }\n', '\n', '    //function that is called when transaction target is a contract\n', '    function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {\n', '        ERC223Receiver reciever = ERC223Receiver(_to);\n', '        return reciever.tokenFallback(msg.sender, _origin, _value, _data);\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        // retrieve the size of the code on target address, this needs assembly\n', '        uint length;\n', '        assembly { length := extcodesize(_addr) }\n', '        return length > 0;\n', '    }\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from Standard223Receiver\n', '\n', '    Tkn tkn;\n', '\n', '    struct Tkn {\n', '        address addr;\n', '        address sender;\n', '        address origin;\n', '        uint256 value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool ok) {\n', '        if (!supportsToken(msg.sender)) return false;\n', '\n', '        // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.\n', '        tkn = Tkn(msg.sender, _sender, _origin, _value, _data, getSig(_data));\n', '        __isTokenFallback = true;\n', '        if (!address(this).delegatecall(_data)) return false;\n', '\n', '        // avoid doing an overwrite to .token, which would be more expensive\n', '        // makes accessing .tkn values outside tokenPayable functions unsafe\n', '        __isTokenFallback = false;\n', '\n', '        return true;\n', '    }\n', '\n', '    function getSig(bytes _data) private pure returns (bytes4 sig) {\n', '        uint l = _data.length < 4 ? _data.length : 4;\n', '        for (uint i = 0; i < l; i++) {\n', '            sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));\n', '        }\n', '    }\n', '\n', '    bool __isTokenFallback;\n', '\n', '    modifier tokenPayable {\n', '        if (!__isTokenFallback) assert(false);\n', '        _;                                                              //_ is a special character used in modifiers\n', '    }\n', '\n', '    //function supportsToken(address token) public pure returns (bool);  //moved up\n', '\n', '//-------------------------------------------------------------------------------------\n', '//from ExampleReceiver\n', '\n', '/*\n', '//we do not use dedicated function to receive Token in contract associated account\n', '    function foo(\n', '        //uint i\n', '        ) tokenPayable public {\n', '        emit LogTokenPayable(1, tkn.addr, tkn.sender, tkn.value);\n', '    }\n', '*/\n', '    function () tokenPayable public {\n', '        emit LogTokenPayable(0, tkn.addr, tkn.sender, tkn.value);\n', '    }\n', '\n', '      function supportsToken(address token) public view returns (bool) {\n', '        //do not need to to anything with that token address?\n', '        //if (token == 0) { //attila addition\n', "        if (token != thisContract) { //attila addition, support only our own token, not others' token\n", '            return false;\n', '        }\n', '        if(!isTokenSupport) {  //attila addition\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    event LogTokenPayable(uint i, address token, address sender, uint value);\n', '  \n', '//-------------------------------------------------------------------------------------\n', '// My extensions\n', '/*\n', '    function enableTokenSupport(bool _tokenSupport) public returns (bool success) {\n', '        if(msg.sender == contrInitiator) {\n', '            isTokenSupport = _tokenSupport;\n', '            return true;\n', '        } else {\n', '            return false;  \n', '        }\n', '    }\n', '*/\n', '    function setIsAllTransfersLocked(bool _lock) public {\n', '        require(msg.sender == contrInitiator);\n', '        isAllTransfersLocked = _lock;\n', '    }\n', '\n', '    function setIsSendingLocked(address _from, bool _lock) public {\n', '        require(msg.sender == contrInitiator);\n', '        isSendingLocked[_from] = _lock;\n', '    }\n', '\n', '    function getIsAllTransfersLocked() public view returns (bool ok) {\n', '        return isAllTransfersLocked;\n', '    }\n', '\n', '    function getIsSendingLocked(address _from ) public view returns (bool ok) {\n', '        return isSendingLocked[_from];\n', '    }\n', ' \n', '/*  \n', '    function getTransferInfoCount(address _from) public view returns (uint count) {\n', '        return transferInfo[_from].tc;\n', '    }\n', '*/    \n', '/*\n', '    // use experimental feature\n', '    function getTransferInfo(address _from, uint index) public view returns (TransferInfo ti) {\n', '        return transferInfo[_from].ti[index];\n', '    }\n', '*/ \n', '/*\n', '    function getTransferInfoTime(address _from, uint index) public view returns (uint time) {\n', '        return transferInfo[_from].ti[index].time;\n', '    }\n', '*/\n', '/*\n', '    function getTransferInfoValue(address _from, uint index) public view returns (uint value) {\n', '        return transferInfo[_from].ti[index].value;\n', '    }\n', '*/\n', '    function getLast24hSendingValue(address _from) public view returns (uint totVal) {\n', '      \n', '        totVal = 0;  //declared above;\n', '        uint tc = transferInfo[_from].tc;\n', '      \n', '        if(tc > 0) {\n', '            for(uint i = tc-1 ; i >= 0 ; i--) {\n', '//              if(now - transferInfo[_from].ti[i].time < 10 minutes) {\n', '//              if(now - transferInfo[_from].ti[i].time < 1 hours) {\n', '                if(now - transferInfo[_from].ti[i].time < 1 days) {\n', '                    totVal = safeAdd(totVal, transferInfo[_from].ti[i].value );\n', '                } else {\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    \n', '    function airdropIndividual(address[] _recipients, uint256[] _values, uint256 _elemCount, uint _totalValue)  public returns (bool success) {\n', '        \n', '        require(_recipients.length == _elemCount);\n', '        require(_values.length == _elemCount); \n', '        \n', '        uint256 totalValue = 0;\n', '        for(uint i = 0; i< _recipients.length; i++) {\n', '            totalValue = safeAdd(totalValue, _values[i]);\n', '        }\n', '        \n', '        require(totalValue == _totalValue);\n', '        \n', '        for(i = 0; i< _recipients.length; i++) {\n', '            transfer(_recipients[i], _values[i]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '}']
