['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev Owner validator\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        \n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title BasicToken\n', ' * @dev Implementation of ERC20Basic\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in exsitence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function msgSender() \n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return msg.sender;\n', '    }\n', '\n', '    function transfer(\n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        public \n', '        returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_to != msg.sender);\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        _preValidateTransfer(msg.sender, _to, _value);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function _preValidateTransfer(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        internal \n', '    {\n', '\n', '    }\n', '}\n', '\n', '/**\n', ' * @title StandardToken\n', ' * @dev Base Of token\n', ' */\n', 'contract StandardToken is ERC20, BasicToken, Ownable {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address the address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        public \n', '        returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        _preValidateTransfer(_from, _to, _value);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].sub(_value);  \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true; \n', '    } \n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender\n', '.   * @param _spender The address which will spend the funds.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed jto a spender. \n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '/**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title MintableToken\n', ' * @dev Minting of total balance \n', ' */\n', 'contract MintableToken is StandardToken {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '   \n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint\n', '    * @return A boolean that indicated if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwner   canMint public returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful. \n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title LockableToken\n', ' * @dev locking of granted balance\n', ' */\n', 'contract LockableToken is MintableToken {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev Lock defines a lock of token\n', '     */\n', '    struct Lock {\n', '        uint256 amount;\n', '        uint256 expiresAt;\n', '    }\n', '\n', '    // granted to locks;\n', '    mapping (address => Lock[]) public grantedLocks;\n', '\n', '    function addLock(\n', '        address _granted, \n', '        uint256 _amount, \n', '        uint256 _expiresAt\n', '    ) \n', '        public \n', '        onlyOwner \n', '    {\n', '        require(_amount > 0);\n', '        require(_expiresAt > now);\n', '\n', '        grantedLocks[_granted].push(Lock(_amount, _expiresAt));\n', '    }\n', '\n', '    function deleteLock(\n', '        address _granted, \n', '        uint8 _index\n', '    ) \n', '        public \n', '        onlyOwner \n', '    {\n', '        Lock storage lock = grantedLocks[_granted][_index];\n', '\n', '        delete grantedLocks[_granted][_index];\n', '        for (uint i = _index; i < grantedLocks[_granted].length - 1; i++) {\n', '            grantedLocks[_granted][i] = grantedLocks[_granted][i+1];\n', '        }\n', '        grantedLocks[_granted].length--;\n', '\n', '        if (grantedLocks[_granted].length == 0)\n', '            delete grantedLocks[_granted];\n', '    }\n', '\n', '    function transferWithLock(\n', '        address _to, \n', '        uint256 _value,\n', '        uint256[] _expiresAtList\n', '    ) \n', '        public \n', '        onlyOwner\n', '        returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_to != msg.sender);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        uint256 count = _expiresAtList.length;\n', '        if (count > 0) {\n', '            uint256 devidedValue = _value.div(count);\n', '            for (uint i = 0; i < count; i++) {\n', '                addLock(_to, devidedValue, _expiresAtList[i]);  \n', '            }\n', '        }\n', '\n', '        return transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '        @param _from - _granted\n', '        @param _to - no usable\n', '        @param _value - amount of transfer\n', '     */\n', '    function _preValidateTransfer(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        internal\n', '    {\n', '        super._preValidateTransfer(_from, _to, _value);\n', '        \n', '        uint256 lockedAmount = getLockedAmount(_from);\n', '        uint256 balanceAmount = balanceOf(_from);\n', '\n', '        require(balanceAmount.sub(lockedAmount) >= _value);\n', '    }\n', '\n', '\n', '    function getLockedAmount(\n', '        address _granted\n', '    ) \n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '\n', '        uint256 lockedAmount = 0;\n', '\n', '        Lock[] storage locks = grantedLocks[_granted];\n', '        for (uint i = 0; i < locks.length; i++) {\n', '            if (now < locks[i].expiresAt) {\n', '                lockedAmount = lockedAmount.add(locks[i].amount);\n', '            }\n', '        }\n', '        //uint256 balanceAmount = balanceOf(_granted);\n', '        //return balanceAmount.sub(lockedAmount);\n', '\n', '        return lockedAmount;\n', '    }\n', '    \n', '}\n', '\n', '\n', 'contract BPXToken is LockableToken {\n', '\n', '  string public constant name = "Bitcoin Pay";\n', '  string public constant symbol = "BPX";\n', '  uint32 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));\n', '\n', '  /**\n', '  * @dev Constructor that gives msg.sender all of existing tokens.\n', '  */\n', '  constructor() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev Owner validator\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        \n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title BasicToken\n', ' * @dev Implementation of ERC20Basic\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in exsitence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function msgSender() \n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return msg.sender;\n', '    }\n', '\n', '    function transfer(\n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        public \n', '        returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_to != msg.sender);\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        _preValidateTransfer(msg.sender, _to, _value);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function _preValidateTransfer(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        internal \n', '    {\n', '\n', '    }\n', '}\n', '\n', '/**\n', ' * @title StandardToken\n', ' * @dev Base Of token\n', ' */\n', 'contract StandardToken is ERC20, BasicToken, Ownable {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address the address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        public \n', '        returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        _preValidateTransfer(_from, _to, _value);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].sub(_value);  \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true; \n', '    } \n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender\n', '.   * @param _spender The address which will spend the funds.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed jto a spender. \n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '/**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title MintableToken\n', ' * @dev Minting of total balance \n', ' */\n', 'contract MintableToken is StandardToken {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '   \n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint\n', '    * @return A boolean that indicated if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwner   canMint public returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful. \n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title LockableToken\n', ' * @dev locking of granted balance\n', ' */\n', 'contract LockableToken is MintableToken {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev Lock defines a lock of token\n', '     */\n', '    struct Lock {\n', '        uint256 amount;\n', '        uint256 expiresAt;\n', '    }\n', '\n', '    // granted to locks;\n', '    mapping (address => Lock[]) public grantedLocks;\n', '\n', '    function addLock(\n', '        address _granted, \n', '        uint256 _amount, \n', '        uint256 _expiresAt\n', '    ) \n', '        public \n', '        onlyOwner \n', '    {\n', '        require(_amount > 0);\n', '        require(_expiresAt > now);\n', '\n', '        grantedLocks[_granted].push(Lock(_amount, _expiresAt));\n', '    }\n', '\n', '    function deleteLock(\n', '        address _granted, \n', '        uint8 _index\n', '    ) \n', '        public \n', '        onlyOwner \n', '    {\n', '        Lock storage lock = grantedLocks[_granted][_index];\n', '\n', '        delete grantedLocks[_granted][_index];\n', '        for (uint i = _index; i < grantedLocks[_granted].length - 1; i++) {\n', '            grantedLocks[_granted][i] = grantedLocks[_granted][i+1];\n', '        }\n', '        grantedLocks[_granted].length--;\n', '\n', '        if (grantedLocks[_granted].length == 0)\n', '            delete grantedLocks[_granted];\n', '    }\n', '\n', '    function transferWithLock(\n', '        address _to, \n', '        uint256 _value,\n', '        uint256[] _expiresAtList\n', '    ) \n', '        public \n', '        onlyOwner\n', '        returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_to != msg.sender);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        uint256 count = _expiresAtList.length;\n', '        if (count > 0) {\n', '            uint256 devidedValue = _value.div(count);\n', '            for (uint i = 0; i < count; i++) {\n', '                addLock(_to, devidedValue, _expiresAtList[i]);  \n', '            }\n', '        }\n', '\n', '        return transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '        @param _from - _granted\n', '        @param _to - no usable\n', '        @param _value - amount of transfer\n', '     */\n', '    function _preValidateTransfer(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        internal\n', '    {\n', '        super._preValidateTransfer(_from, _to, _value);\n', '        \n', '        uint256 lockedAmount = getLockedAmount(_from);\n', '        uint256 balanceAmount = balanceOf(_from);\n', '\n', '        require(balanceAmount.sub(lockedAmount) >= _value);\n', '    }\n', '\n', '\n', '    function getLockedAmount(\n', '        address _granted\n', '    ) \n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '\n', '        uint256 lockedAmount = 0;\n', '\n', '        Lock[] storage locks = grantedLocks[_granted];\n', '        for (uint i = 0; i < locks.length; i++) {\n', '            if (now < locks[i].expiresAt) {\n', '                lockedAmount = lockedAmount.add(locks[i].amount);\n', '            }\n', '        }\n', '        //uint256 balanceAmount = balanceOf(_granted);\n', '        //return balanceAmount.sub(lockedAmount);\n', '\n', '        return lockedAmount;\n', '    }\n', '    \n', '}\n', '\n', '\n', 'contract BPXToken is LockableToken {\n', '\n', '  string public constant name = "Bitcoin Pay";\n', '  string public constant symbol = "BPX";\n', '  uint32 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));\n', '\n', '  /**\n', '  * @dev Constructor that gives msg.sender all of existing tokens.\n', '  */\n', '  constructor() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '}']