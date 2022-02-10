['pragma solidity ^0.4.11;\n', '\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '    /**\n', '        constructor\n', '    */\n', '    function Utils() {\n', '    }\n', '\n', '    // verifies that an amount is greater than zero\n', '    modifier greaterThanZero(uint256 _amount) {\n', '        require(_amount > 0);\n', '        _;\n', '    }\n', '\n', '    // validates an address - currently only checks that it isn&#39;t null\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', '    // this function isn&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function owner() public constant returns (address owner) { owner; }\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '/*\n', '    We consider every contract to be a &#39;token holder&#39; since it&#39;s currently not possible\n', '    for a contract to deny receiving tokens.\n', '\n', '    The TokenHolder&#39;s contract sole purpose is to provide a safety mechanism that allows\n', '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned, Utils {\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function TokenHolder() {\n', '    }\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', '    // these functions aren&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function name() public constant returns (string name) { name; }\n', '    function symbol() public constant returns (string symbol) { symbol; }\n', '    function decimals() public constant returns (uint8 decimals) { decimals; }\n', '    function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '/**\n', '    ERC20 Standard Token implementation\n', '*/\n', 'contract ERC20Token is IERC20Token, Utils {\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public name = &#39;&#39;;\n', '    string public symbol = &#39;&#39;;\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply = 0;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _name        token name\n', '        @param _symbol      token symbol\n', '        @param _decimals    decimal points, for display purposes\n', '    */\n', '    function ERC20Token(string _name, string _symbol, uint8 _decimals) {\n', '        require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev allow another account/contract to spend some tokens on your behalf\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        also, to minimize the risk of the approve/transferFrom attack vector\n', '        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice\n', '        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value\n', '\n', '        @param _spender approved address\n', '        @param _value   allowance amount\n', '\n', '        @return true if the approval was successful, false if it wasn&#39;t\n', '    */\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', '        // if the allowance isn&#39;t 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/*\n', '    Ether Token interface\n', '*/\n', 'contract IEtherToken is ITokenHolder, IERC20Token {\n', '    function deposit() public payable;\n', '    function withdraw(uint256 _amount) public;\n', '    function withdrawTo(address _to, uint256 _amount);\n', '}\n', '\n', '/**\n', '    Ether tokenization contract\n', '\n', '    &#39;Owned&#39; is specified here for readability reasons\n', '*/\n', 'contract EtherToken1 is IEtherToken, Owned, ERC20Token, TokenHolder {\n', '    // triggered when the total supply is increased\n', '    event Issuance(uint256 _amount);\n', '    // triggered when the total supply is decreased\n', '    event Destruction(uint256 _amount);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function EtherToken1()\n', '        ERC20Token(&#39;Ether Token&#39;, &#39;ETH&#39;, 18) {\n', '    }\n', '\n', '    /**\n', '        @dev deposit ether in the account\n', '    */\n', '    function deposit() public payable {\n', '        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value); // add the value to the account balance\n', '        totalSupply = safeAdd(totalSupply, msg.value); // increase the total supply\n', '\n', '        Issuance(msg.value);\n', '        Transfer(this, msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '        @dev withdraw ether from the account\n', '\n', '        @param _amount  amount of ether to withdraw\n', '    */\n', '    function withdraw(uint256 _amount) public {\n', '        withdrawTo(msg.sender, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev withdraw ether from the account to a target account\n', '\n', '        @param _to      account to receive the ether\n', '        @param _amount  amount of ether to withdraw\n', '    */\n', '    function withdrawTo(address _to, uint256 _amount)\n', '        public\n', '        notThis(_to)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount); // deduct the amount from the account balance\n', '        totalSupply = safeSub(totalSupply, _amount); // decrease the total supply\n', '        _to.transfer(_amount); // send the amount to the target account\n', '\n', '        Transfer(msg.sender, this, _amount);\n', '        Destruction(_amount);\n', '    }\n', '\n', '    // ERC20 standard method overrides with some extra protection\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        notThis(_to)\n', '        returns (bool success)\n', '    {\n', '        assert(super.transfer(_to, _value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        notThis(_to)\n', '        returns (bool success)\n', '    {\n', '        assert(super.transferFrom(_from, _to, _value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev deposit ether in the account\n', '    */\n', '    function() public payable {\n', '        deposit();\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '    /**\n', '        constructor\n', '    */\n', '    function Utils() {\n', '    }\n', '\n', '    // verifies that an amount is greater than zero\n', '    modifier greaterThanZero(uint256 _amount) {\n', '        require(_amount > 0);\n', '        _;\n', '    }\n', '\n', "    // validates an address - currently only checks that it isn't null\n", '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', "    // this function isn't abstract since the compiler emits automatically generated getter functions as external\n", '    function owner() public constant returns (address owner) { owner; }\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '/*\n', "    We consider every contract to be a 'token holder' since it's currently not possible\n", '    for a contract to deny receiving tokens.\n', '\n', "    The TokenHolder's contract sole purpose is to provide a safety mechanism that allows\n", '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned, Utils {\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function TokenHolder() {\n', '    }\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    function name() public constant returns (string name) { name; }\n', '    function symbol() public constant returns (string symbol) { symbol; }\n', '    function decimals() public constant returns (uint8 decimals) { decimals; }\n', '    function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '/**\n', '    ERC20 Standard Token implementation\n', '*/\n', 'contract ERC20Token is IERC20Token, Utils {\n', "    string public standard = 'Token 0.1';\n", "    string public name = '';\n", "    string public symbol = '';\n", '    uint8 public decimals = 0;\n', '    uint256 public totalSupply = 0;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _name        token name\n', '        @param _symbol      token symbol\n', '        @param _decimals    decimal points, for display purposes\n', '    */\n', '    function ERC20Token(string _name, string _symbol, uint8 _decimals) {\n', '        require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev allow another account/contract to spend some tokens on your behalf\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        also, to minimize the risk of the approve/transferFrom attack vector\n', '        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice\n', '        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value\n', '\n', '        @param _spender approved address\n', '        @param _value   allowance amount\n', '\n', "        @return true if the approval was successful, false if it wasn't\n", '    */\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', "        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n", '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/*\n', '    Ether Token interface\n', '*/\n', 'contract IEtherToken is ITokenHolder, IERC20Token {\n', '    function deposit() public payable;\n', '    function withdraw(uint256 _amount) public;\n', '    function withdrawTo(address _to, uint256 _amount);\n', '}\n', '\n', '/**\n', '    Ether tokenization contract\n', '\n', "    'Owned' is specified here for readability reasons\n", '*/\n', 'contract EtherToken1 is IEtherToken, Owned, ERC20Token, TokenHolder {\n', '    // triggered when the total supply is increased\n', '    event Issuance(uint256 _amount);\n', '    // triggered when the total supply is decreased\n', '    event Destruction(uint256 _amount);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function EtherToken1()\n', "        ERC20Token('Ether Token', 'ETH', 18) {\n", '    }\n', '\n', '    /**\n', '        @dev deposit ether in the account\n', '    */\n', '    function deposit() public payable {\n', '        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value); // add the value to the account balance\n', '        totalSupply = safeAdd(totalSupply, msg.value); // increase the total supply\n', '\n', '        Issuance(msg.value);\n', '        Transfer(this, msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '        @dev withdraw ether from the account\n', '\n', '        @param _amount  amount of ether to withdraw\n', '    */\n', '    function withdraw(uint256 _amount) public {\n', '        withdrawTo(msg.sender, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev withdraw ether from the account to a target account\n', '\n', '        @param _to      account to receive the ether\n', '        @param _amount  amount of ether to withdraw\n', '    */\n', '    function withdrawTo(address _to, uint256 _amount)\n', '        public\n', '        notThis(_to)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount); // deduct the amount from the account balance\n', '        totalSupply = safeSub(totalSupply, _amount); // decrease the total supply\n', '        _to.transfer(_amount); // send the amount to the target account\n', '\n', '        Transfer(msg.sender, this, _amount);\n', '        Destruction(_amount);\n', '    }\n', '\n', '    // ERC20 standard method overrides with some extra protection\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        notThis(_to)\n', '        returns (bool success)\n', '    {\n', '        assert(super.transfer(_to, _value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        notThis(_to)\n', '        returns (bool success)\n', '    {\n', '        assert(super.transferFrom(_from, _to, _value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev deposit ether in the account\n', '    */\n', '    function() public payable {\n', '        deposit();\n', '    }\n', '}']
