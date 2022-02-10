['pragma solidity ^0.4.18;\n', '\n', '/*\n', ' * ERC223 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' * see https://github.com/ethereum/EIPs/issues/223\n', ' */\n', 'contract ERC223 {\n', '    function totalSupply() constant public returns (uint256 outTotalSupply);\n', '    function balanceOf( address _owner) constant public returns (uint256 balance);\n', '    function transfer( address _to, uint256 _value) public returns (bool success);\n', '    function transfer( address _to, uint256 _value, bytes _data) public returns (bool success);\n', '    function transferFrom( address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve( address _spender, uint256 _value) public returns (bool success);\n', '    function allowance( address _owner, address _spender) constant public returns (uint256 remaining);\n', '    event Transfer( address indexed _from, address indexed _to, uint _value, bytes _data);\n', '    event Approval( address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract ERC223Receiver { \n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal pure returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', ' \n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC223\n', ' */\n', 'contract StandardToken is ERC223, SafeMath {\n', '        \n', '    uint256 public supplyNum;\n', '    \n', '    uint256 public decimals;\n', '\n', '    /* Actual mapBalances of token holders */\n', '    mapping(address => uint) mapBalances;\n', '\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) mapApproved;\n', '\n', '    /* Interface declaration */\n', '    function isToken() public pure returns (bool weAre) {\n', '        return true;\n', '    }\n', '\n', '\n', '    function totalSupply() constant public returns (uint256 outTotalSupply) {\n', '        return supplyNum;\n', '    }\n', '\n', '    \n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        mapBalances[msg.sender] = safeSub(mapBalances[msg.sender], _value);\n', '        mapBalances[_to] = safeAdd(mapBalances[_to], _value);\n', '        \n', '        if (codeLength > 0) {\n', '            ERC223Receiver receiver = ERC223Receiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        mapBalances[msg.sender] = safeSub(mapBalances[msg.sender], _value);\n', '        mapBalances[_to] = safeAdd(mapBalances[_to], _value);\n', '        \n', '        if (codeLength > 0) {\n', '            ERC223Receiver receiver = ERC223Receiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value, empty);\n', '        return true;\n', '    }\n', '    \n', '    \n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        mapApproved[_from][msg.sender] = safeSub(mapApproved[_from][msg.sender], _value);\n', '        mapBalances[_from] = safeSub(mapBalances[_from], _value);\n', '        mapBalances[_to] = safeAdd(mapBalances[_to], _value);\n', '        \n', '        bytes memory empty;\n', '        emit Transfer(_from, _to, _value, empty);\n', '                \n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint balance)    {\n', '        return mapBalances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success)    {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //    allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //    already 0 to mitigate the race condition described here:\n', '        //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require (_value != 0); \n', '        require (mapApproved[msg.sender][_spender] == 0);\n', '\n', '        mapApproved[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) view public returns (uint remaining)    {\n', '        return mapApproved[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * Centrally issued Ethereum token.\n', ' *\n', ' * We mix in burnable and upgradeable traits.\n', ' *\n', ' * Token supply is created in the token contract creation and allocated to owner.\n', ' * The owner can then transfer from its supply to crowdsale participants.\n', ' * The owner, or anybody, can burn any excessive tokens they are holding.\n', ' *\n', ' */\n', 'contract BetOnMe is StandardToken {\n', '\n', '    string public name = "BetOnMe";\n', '    string public symbol = "BOM";\n', '    \n', '    \n', '    address public coinMaster;\n', '    \n', '    \n', '    /** Name and symbol were updated. */\n', '    event UpdatedInformation(string newName, string newSymbol);\n', '\n', '    function BetOnMe() public {\n', '        supplyNum = 1000000000000 * (10 ** 18);\n', '        decimals = 18;\n', '        coinMaster = msg.sender;\n', '\n', '        // Allocate initial balance to the owner\n', '        mapBalances[coinMaster] = supplyNum;\n', '    }\n', '\n', '    /**\n', '     * Owner can update token information here.\n', '     *\n', '     * It is often useful to conceal the actual token association, until\n', '     * the token operations, like central issuance or reissuance have been completed.\n', '     * In this case the initial token can be supplied with empty name and symbol information.\n', '     *\n', '     * This function allows the token owner to rename the token after the operations\n', '     * have been completed and then point the audience to use the token contract.\n', '     */\n', '    function setTokenInformation(string _name, string _symbol) public {\n', '        require(msg.sender == coinMaster) ;\n', '\n', '        require(bytes(name).length > 0 && bytes(symbol).length > 0);\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        emit UpdatedInformation(name, symbol);\n', '    }\n', '    \n', '    \n', '    \n', '    /// transfer dead tokens to contract master\n', '    function withdrawTokens() external {\n', '        uint256 fundNow = balanceOf(this);\n', '        transfer(coinMaster, fundNow);//token\n', '        \n', '        uint256 balance = address(this).balance;\n', '        coinMaster.transfer(balance);//eth\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/*\n', ' * ERC223 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' * see https://github.com/ethereum/EIPs/issues/223\n', ' */\n', 'contract ERC223 {\n', '    function totalSupply() constant public returns (uint256 outTotalSupply);\n', '    function balanceOf( address _owner) constant public returns (uint256 balance);\n', '    function transfer( address _to, uint256 _value) public returns (bool success);\n', '    function transfer( address _to, uint256 _value, bytes _data) public returns (bool success);\n', '    function transferFrom( address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve( address _spender, uint256 _value) public returns (bool success);\n', '    function allowance( address _owner, address _spender) constant public returns (uint256 remaining);\n', '    event Transfer( address indexed _from, address indexed _to, uint _value, bytes _data);\n', '    event Approval( address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract ERC223Receiver { \n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal pure returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', ' \n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC223\n', ' */\n', 'contract StandardToken is ERC223, SafeMath {\n', '        \n', '    uint256 public supplyNum;\n', '    \n', '    uint256 public decimals;\n', '\n', '    /* Actual mapBalances of token holders */\n', '    mapping(address => uint) mapBalances;\n', '\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) mapApproved;\n', '\n', '    /* Interface declaration */\n', '    function isToken() public pure returns (bool weAre) {\n', '        return true;\n', '    }\n', '\n', '\n', '    function totalSupply() constant public returns (uint256 outTotalSupply) {\n', '        return supplyNum;\n', '    }\n', '\n', '    \n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        mapBalances[msg.sender] = safeSub(mapBalances[msg.sender], _value);\n', '        mapBalances[_to] = safeAdd(mapBalances[_to], _value);\n', '        \n', '        if (codeLength > 0) {\n', '            ERC223Receiver receiver = ERC223Receiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        mapBalances[msg.sender] = safeSub(mapBalances[msg.sender], _value);\n', '        mapBalances[_to] = safeAdd(mapBalances[_to], _value);\n', '        \n', '        if (codeLength > 0) {\n', '            ERC223Receiver receiver = ERC223Receiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value, empty);\n', '        return true;\n', '    }\n', '    \n', '    \n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        mapApproved[_from][msg.sender] = safeSub(mapApproved[_from][msg.sender], _value);\n', '        mapBalances[_from] = safeSub(mapBalances[_from], _value);\n', '        mapBalances[_to] = safeAdd(mapBalances[_to], _value);\n', '        \n', '        bytes memory empty;\n', '        emit Transfer(_from, _to, _value, empty);\n', '                \n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint balance)    {\n', '        return mapBalances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success)    {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //    allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //    already 0 to mitigate the race condition described here:\n', '        //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require (_value != 0); \n', '        require (mapApproved[msg.sender][_spender] == 0);\n', '\n', '        mapApproved[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) view public returns (uint remaining)    {\n', '        return mapApproved[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * Centrally issued Ethereum token.\n', ' *\n', ' * We mix in burnable and upgradeable traits.\n', ' *\n', ' * Token supply is created in the token contract creation and allocated to owner.\n', ' * The owner can then transfer from its supply to crowdsale participants.\n', ' * The owner, or anybody, can burn any excessive tokens they are holding.\n', ' *\n', ' */\n', 'contract BetOnMe is StandardToken {\n', '\n', '    string public name = "BetOnMe";\n', '    string public symbol = "BOM";\n', '    \n', '    \n', '    address public coinMaster;\n', '    \n', '    \n', '    /** Name and symbol were updated. */\n', '    event UpdatedInformation(string newName, string newSymbol);\n', '\n', '    function BetOnMe() public {\n', '        supplyNum = 1000000000000 * (10 ** 18);\n', '        decimals = 18;\n', '        coinMaster = msg.sender;\n', '\n', '        // Allocate initial balance to the owner\n', '        mapBalances[coinMaster] = supplyNum;\n', '    }\n', '\n', '    /**\n', '     * Owner can update token information here.\n', '     *\n', '     * It is often useful to conceal the actual token association, until\n', '     * the token operations, like central issuance or reissuance have been completed.\n', '     * In this case the initial token can be supplied with empty name and symbol information.\n', '     *\n', '     * This function allows the token owner to rename the token after the operations\n', '     * have been completed and then point the audience to use the token contract.\n', '     */\n', '    function setTokenInformation(string _name, string _symbol) public {\n', '        require(msg.sender == coinMaster) ;\n', '\n', '        require(bytes(name).length > 0 && bytes(symbol).length > 0);\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        emit UpdatedInformation(name, symbol);\n', '    }\n', '    \n', '    \n', '    \n', '    /// transfer dead tokens to contract master\n', '    function withdrawTokens() external {\n', '        uint256 fundNow = balanceOf(this);\n', '        transfer(coinMaster, fundNow);//token\n', '        \n', '        uint256 balance = address(this).balance;\n', '        coinMaster.transfer(balance);//eth\n', '    }\n', '\n', '}']
