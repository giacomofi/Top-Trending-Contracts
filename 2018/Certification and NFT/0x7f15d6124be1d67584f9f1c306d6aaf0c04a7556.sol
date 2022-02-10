['pragma solidity 0.4.16;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function balanceOf(address _owner) public constant returns (uint balance) {}\n', '    function transfer(address _to, uint _value) public {}\n', '    function transferFrom(address _from, address _to, uint _value) public {}\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', '\n', 'Copyright Will Harborne (Ethfinex) 2017\n', '\n', '*/\n', '\n', 'contract WrapperLock is BasicToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '\n', '    address public TRANSFER_PROXY;\n', '    mapping (address => bool) private isSigner;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    address public originalToken;\n', '\n', '    mapping (address => uint256) public depositLock;\n', '    mapping (address => uint256) public balances;\n', '\n', '    function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals, address _transferProxy) {\n', '        originalToken = _originalToken;\n', '        TRANSFER_PROXY = _transferProxy;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        isSigner[msg.sender] = true;\n', '    }\n', '\n', '    function deposit(uint _value, uint _forTime) public returns (bool) {\n', '        require(_forTime >= 1);\n', '        require(now + _forTime * 1 hours >= depositLock[msg.sender]);\n', '        ERC20Interface token = ERC20Interface(originalToken);\n', '        token.transferFrom(msg.sender, address(this), _value);\n', '        balances[msg.sender] = balances[msg.sender].add(_value);\n', '        depositLock[msg.sender] = now + _forTime * 1 hours;\n', '        return true;\n', '    }\n', '\n', '    function withdraw(\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s,\n', '        uint _value,\n', '        uint signatureValidUntilBlock\n', '    )\n', '        public\n', '        returns\n', '        (bool)\n', '    {\n', '        require(balanceOf(msg.sender) >= _value);\n', '        if (now > depositLock[msg.sender]) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            ERC20Interface(originalToken).transfer(msg.sender, _value);\n', '        } else {\n', '            require(block.number < signatureValidUntilBlock);\n', '            require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            ERC20Interface(originalToken).transfer(msg.sender, _value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        return false;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public {\n', '        require(_to == owner || _from == owner);\n', '        assert(msg.sender == TRANSFER_PROXY);\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint) {\n', '        if (_spender == TRANSFER_PROXY) {\n', '            return 2**256 - 1;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function isValidSignature(\n', '        bytes32 hash,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '        public\n', '        constant\n', '        returns (bool)\n', '    {\n', '        return isSigner[ecrecover(\n', '            keccak256("\\x19Ethereum Signed Message:\\n32", hash),\n', '            v,\n', '            r,\n', '            s\n', '        )];\n', '    }\n', '\n', '    function addSigner(address _newSigner) public {\n', '        require(isSigner[msg.sender]);\n', '        isSigner[_newSigner] = true;\n', '    }\n', '\n', '    function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {\n', '        return keccak256(_sender, _wrapper, _validTill);\n', '    }\n', '\n', '}']
['pragma solidity 0.4.16;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function balanceOf(address _owner) public constant returns (uint balance) {}\n', '    function transfer(address _to, uint _value) public {}\n', '    function transferFrom(address _from, address _to, uint _value) public {}\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', '\n', 'Copyright Will Harborne (Ethfinex) 2017\n', '\n', '*/\n', '\n', 'contract WrapperLock is BasicToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '\n', '    address public TRANSFER_PROXY;\n', '    mapping (address => bool) private isSigner;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    address public originalToken;\n', '\n', '    mapping (address => uint256) public depositLock;\n', '    mapping (address => uint256) public balances;\n', '\n', '    function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals, address _transferProxy) {\n', '        originalToken = _originalToken;\n', '        TRANSFER_PROXY = _transferProxy;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        isSigner[msg.sender] = true;\n', '    }\n', '\n', '    function deposit(uint _value, uint _forTime) public returns (bool) {\n', '        require(_forTime >= 1);\n', '        require(now + _forTime * 1 hours >= depositLock[msg.sender]);\n', '        ERC20Interface token = ERC20Interface(originalToken);\n', '        token.transferFrom(msg.sender, address(this), _value);\n', '        balances[msg.sender] = balances[msg.sender].add(_value);\n', '        depositLock[msg.sender] = now + _forTime * 1 hours;\n', '        return true;\n', '    }\n', '\n', '    function withdraw(\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s,\n', '        uint _value,\n', '        uint signatureValidUntilBlock\n', '    )\n', '        public\n', '        returns\n', '        (bool)\n', '    {\n', '        require(balanceOf(msg.sender) >= _value);\n', '        if (now > depositLock[msg.sender]) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            ERC20Interface(originalToken).transfer(msg.sender, _value);\n', '        } else {\n', '            require(block.number < signatureValidUntilBlock);\n', '            require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            ERC20Interface(originalToken).transfer(msg.sender, _value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        return false;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public {\n', '        require(_to == owner || _from == owner);\n', '        assert(msg.sender == TRANSFER_PROXY);\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint) {\n', '        if (_spender == TRANSFER_PROXY) {\n', '            return 2**256 - 1;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function isValidSignature(\n', '        bytes32 hash,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '        public\n', '        constant\n', '        returns (bool)\n', '    {\n', '        return isSigner[ecrecover(\n', '            keccak256("\\x19Ethereum Signed Message:\\n32", hash),\n', '            v,\n', '            r,\n', '            s\n', '        )];\n', '    }\n', '\n', '    function addSigner(address _newSigner) public {\n', '        require(isSigner[msg.sender]);\n', '        isSigner[_newSigner] = true;\n', '    }\n', '\n', '    function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {\n', '        return keccak256(_sender, _wrapper, _validTill);\n', '    }\n', '\n', '}']
