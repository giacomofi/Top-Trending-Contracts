['pragma solidity ^0.4.18;\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', '    // these functions aren&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', '    // this function isn&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function owner() public view returns (address) {}\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '\n', '\n', '\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '\n', '    // verifies that an amount is greater than zero\n', '    modifier greaterThanZero(uint256 _amount) {\n', '        require(_amount > 0);\n', '        _;\n', '    }\n', '\n', '    // validates an address - currently only checks that it isn&#39;t null\n', '    modifier validAddress(address _address) {\n', '        require(_address != address(0));\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', '    ERC20 Standard Token implementation\n', '*/\n', 'contract ERC20Token is IERC20Token, Utils {\n', '    string public standard = "Token 0.1";\n', '    string public name = "";\n', '    string public symbol = "";\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply = 0;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _name        token name\n', '        @param _symbol      token symbol\n', '        @param _decimals    decimal points, for display purposes\n', '    */\n', '    constructor(string _name, string _symbol, uint8 _decimals) public {\n', '        require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev allow another account/contract to spend some tokens on your behalf\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        also, to minimize the risk of the approve/transferFrom attack vector\n', '        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice\n', '        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value\n', '\n', '        @param _spender approved address\n', '        @param _value   allowance amount\n', '\n', '        @return true if the approval was successful, false if it wasn&#39;t\n', '    */\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', '        // if the allowance isn&#39;t 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '\n', '\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '/*\n', '    We consider every contract to be a &#39;token holder&#39; since it&#39;s currently not possible\n', '    for a contract to deny receiving tokens.\n', '\n', '    The TokenHolder&#39;s contract sole purpose is to provide a safety mechanism that allows\n', '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned, Utils {\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract ISmartToken is IOwned, IERC20Token {\n', '    function disableTransfers(bool _disable) public;\n', '    function issue(address _to, uint256 _amount) public;\n', '    function destroy(address _from, uint256 _amount) public;\n', '}\n', '\n', '\n', 'contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {\n', '    string public version = "";\n', '    bool public transfersEnabled = true;\n', '    event NewSmartToken(address _token);\n', '    event Issuance(uint256 _amount);\n', '    event Destruction(uint256 _amount);\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals)\n', '        public\n', '        ERC20Token(_name, _symbol, _decimals)\n', '    {\n', '        emit NewSmartToken(address(this));\n', '    }\n', '\n', '    modifier transfersAllowed {\n', '        assert(transfersEnabled);\n', '        _;\n', '    }\n', '\n', '    function disableTransfers(bool _disable) public ownerOnly {\n', '        transfersEnabled = !_disable;\n', '    }\n', '\n', '    function issue(address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        totalSupply = safeAdd(totalSupply, _amount);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _amount);\n', '\n', '        emit Issuance(_amount);\n', '        emit Transfer(this, _to, _amount);\n', '    }\n', '\n', '    function destroy(address _from, uint256 _amount) public {\n', '        require(msg.sender == _from || msg.sender == owner);\n', '\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _amount);\n', '        totalSupply = safeSub(totalSupply, _amount);\n', '\n', '        emit Transfer(_from, this, _amount);\n', '        emit Destruction(_amount);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {\n', '        assert(super.transfer(_to, _value));\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {\n', '        assert(super.transferFrom(_from, _to, _value));\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', "    // this function isn't abstract since the compiler emits automatically generated getter functions as external\n", '    function owner() public view returns (address) {}\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '\n', '\n', '\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '\n', '    // verifies that an amount is greater than zero\n', '    modifier greaterThanZero(uint256 _amount) {\n', '        require(_amount > 0);\n', '        _;\n', '    }\n', '\n', "    // validates an address - currently only checks that it isn't null\n", '    modifier validAddress(address _address) {\n', '        require(_address != address(0));\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', '    ERC20 Standard Token implementation\n', '*/\n', 'contract ERC20Token is IERC20Token, Utils {\n', '    string public standard = "Token 0.1";\n', '    string public name = "";\n', '    string public symbol = "";\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply = 0;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _name        token name\n', '        @param _symbol      token symbol\n', '        @param _decimals    decimal points, for display purposes\n', '    */\n', '    constructor(string _name, string _symbol, uint8 _decimals) public {\n', '        require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev allow another account/contract to spend some tokens on your behalf\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        also, to minimize the risk of the approve/transferFrom attack vector\n', '        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice\n', '        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value\n', '\n', '        @param _spender approved address\n', '        @param _value   allowance amount\n', '\n', "        @return true if the approval was successful, false if it wasn't\n", '    */\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', "        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n", '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '\n', '\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '/*\n', "    We consider every contract to be a 'token holder' since it's currently not possible\n", '    for a contract to deny receiving tokens.\n', '\n', "    The TokenHolder's contract sole purpose is to provide a safety mechanism that allows\n", '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned, Utils {\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract ISmartToken is IOwned, IERC20Token {\n', '    function disableTransfers(bool _disable) public;\n', '    function issue(address _to, uint256 _amount) public;\n', '    function destroy(address _from, uint256 _amount) public;\n', '}\n', '\n', '\n', 'contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {\n', '    string public version = "";\n', '    bool public transfersEnabled = true;\n', '    event NewSmartToken(address _token);\n', '    event Issuance(uint256 _amount);\n', '    event Destruction(uint256 _amount);\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals)\n', '        public\n', '        ERC20Token(_name, _symbol, _decimals)\n', '    {\n', '        emit NewSmartToken(address(this));\n', '    }\n', '\n', '    modifier transfersAllowed {\n', '        assert(transfersEnabled);\n', '        _;\n', '    }\n', '\n', '    function disableTransfers(bool _disable) public ownerOnly {\n', '        transfersEnabled = !_disable;\n', '    }\n', '\n', '    function issue(address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        totalSupply = safeAdd(totalSupply, _amount);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _amount);\n', '\n', '        emit Issuance(_amount);\n', '        emit Transfer(this, _to, _amount);\n', '    }\n', '\n', '    function destroy(address _from, uint256 _amount) public {\n', '        require(msg.sender == _from || msg.sender == owner);\n', '\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _amount);\n', '        totalSupply = safeSub(totalSupply, _amount);\n', '\n', '        emit Transfer(_from, this, _amount);\n', '        emit Destruction(_amount);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {\n', '        assert(super.transfer(_to, _value));\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {\n', '        assert(super.transferFrom(_from, _to, _value));\n', '        return true;\n', '    }\n', '}']
