['pragma solidity >=0.5.0 <0.6.0;\n', '\n', '/**\n', ' * @title SafeMath for uint256\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMathUint256 {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath: Multiplier exception");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b; // Solidity automatically throws when dividing by 0\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: Subtraction exception");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath: Addition exception");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: Modulo exception");\n', '        return a % b;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath for uint8\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMathUint8 {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath: Multiplier exception");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        return a / b; // Solidity automatically throws when dividing by 0\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        require(b <= a, "SafeMath: Subtraction exception");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint8 a, uint8 b) internal pure returns (uint8 c) {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath: Addition exception");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        require(b != 0, "SafeMath: Modulo exception");\n', '        return a % b;\n', '    }\n', '\n', '}\n', '\n', 'contract Ownership {\n', '    address payable public owner;\n', '    address payable public pendingOwner;\n', '\n', '    event OwnershipTransferred (address indexed from, address indexed to);\n', '\n', '    constructor () public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require (msg.sender == owner, "Ownership: Access denied");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership (address payable _pendingOwner) public\n', '        onlyOwner\n', '    {\n', '        pendingOwner = _pendingOwner;\n', '    }\n', '\n', '    function acceptOwnership () public\n', '    {\n', '        require (msg.sender == pendingOwner, "Ownership: Only new owner is allowed");\n', '\n', '        emit OwnershipTransferred (owner, pendingOwner);\n', '\n', '        owner = pendingOwner;\n', '        pendingOwner = address(0);\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Controllable contract\n', ' * @dev Implementation of the controllable operations\n', ' */\n', 'contract Controllable is Ownership {\n', '\n', '    bool public stopped;\n', '    mapping (address => bool) public freezeAddresses;\n', '\n', '    event Paused();\n', '    event Resumed();\n', '\n', '    event FreezeAddress(address indexed addressOf);\n', '    event UnfreezeAddress(address indexed addressOf);\n', '\n', '    modifier onlyActive(address _sender) {\n', '        require(!freezeAddresses[_sender], "Controllable: Not active");\n', '        _;\n', '    }\n', '\n', '    modifier isUsable {\n', '        require(!stopped, "Controllable: Paused");\n', '        _;\n', '    }\n', '\n', '    function pause () public\n', '        onlyOwner\n', '    {\n', '        stopped = true;\n', '        emit Paused ();\n', '    }\n', '    \n', '    function resume () public\n', '        onlyOwner\n', '    {\n', '        stopped = false;\n', '        emit Resumed ();\n', '    }\n', '\n', '    function freezeAddress(address _addressOf) public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        if (!freezeAddresses[_addressOf]) {\n', '            freezeAddresses[_addressOf] = true;\n', '            emit FreezeAddress(_addressOf);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\t\n', '    function unfreezeAddress(address _addressOf) public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        if (freezeAddresses[_addressOf]) {\n', '            delete freezeAddresses[_addressOf];\n', '            emit UnfreezeAddress(_addressOf);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic, Controllable {\n', '    using SafeMathUint256 for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    constructor(uint256 _initialSupply) public\n', '    {\n', '        totalSupply = _initialSupply;\n', '\n', '        if (0 < _initialSupply) {\n', '            balances[msg.sender] = _initialSupply;\n', '            emit Transfer(address(0), msg.sender, _initialSupply);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public\n', '        isUsable\n', '        onlyActive(msg.sender)\n', '        onlyActive(_to)\n', '        returns (bool)\n', '    {\n', '        require(0 < _value, "BasicToken.transfer: Zero value");\n', '        require(_value <= balances[msg.sender], "BasicToken.transfer: Insufficient fund");\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view\n', '        returns (uint256 balance)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public\n', '        isUsable\n', '        onlyActive(msg.sender)\n', '        onlyActive(_from)\n', '        onlyActive(_to)\n', '        returns (bool)\n', '    {\n', '        require(0 < _value, "StandardToken.transferFrom: Zero value");\n', '        require(_value <= balances[_from], "StandardToken.transferFrom: Insufficient fund");\n', '        require(_value <= allowed[_from][msg.sender], "StandardToken.transferFrom: Insufficient allowance");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public\n', '        isUsable\n', '        onlyActive(msg.sender)\n', '        onlyActive(_spender)\n', '        returns (bool)\n', '    {\n', '        require(0 < _value, "StandardToken.approve: Zero value");\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    *\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseApproval(address _spender, uint256 _addedValue) public\n', '        isUsable\n', '        onlyActive(msg.sender)\n', '        onlyActive(_spender)\n', '        returns (bool)\n', '    {\n', '        require(0 < _addedValue, "StandardToken.increaseApproval: Zero value");\n', '\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    *\n', '    * approve should be called when allowed[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public\n', '        isUsable\n', '        onlyActive(msg.sender)\n', '        onlyActive(_spender)\n', '        returns (bool)\n', '    {\n', '        require(0 < _subtractedValue, "StandardToken.decreaseApproval: Zero value");\n', '\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '        if (_subtractedValue > oldValue)\n', '            allowed[msg.sender][_spender] = 0;\n', '        else\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract ApprovalReceiver {\n', '    function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes calldata _extraData) external;\n', '}\n', '\n', 'contract USDA is StandardToken {\n', '    using SafeMathUint256 for uint256;\n', '\n', '    bytes32 constant FREEZE_CODE_DEFAULT = 0x0000000000000000000000000000000000000000000000000000000000000000;\n', '\n', '    event Freeze(address indexed from, uint256 value);\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    event FreezeWithPurpose(address indexed from, uint256 value, bytes32 purpose);\n', '    event UnfreezeWithPurpose(address indexed from, uint256 value, bytes32 purpose);\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    // Keep track total frozen balances\n', '    mapping (address => uint256) public freezeOf;\n', '    // Keep track sub total frozen balances\n', '    mapping (address => mapping (bytes32 => uint256)) public freezes;\n', '\n', '    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) public\n', '        BasicToken(_initialSupply)\n', '    {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase total supply (mint) to an address\n', '     *\n', '     * @param _value The amount of tokens to be mint\n', '     * @param _to The address which will receive token\n', '     */\n', '    function increaseSupply(uint256 _value, address _to) external\n', '        onlyOwner\n', '        onlyActive(_to)\n', '        returns (bool)\n', '    {\n', '        require(0 < _value, "StableCoin.increaseSupply: Zero value");\n', '\n', '        totalSupply = totalSupply.add(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(address(0), _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase total supply (mint) to an address with deposit\n', '     *\n', '     * @param _value The amount of tokens to be mint\n', '     * @param _to The address which will receive token\n', '     * @param _deposit The amount of deposit\n', '     */\n', '    function increaseSupplyWithDeposit(uint256 _value, address _to, uint256 _deposit) external\n', '        onlyOwner\n', '        onlyActive(_to)\n', '        returns (bool)\n', '    {\n', '        require(0 < _value, "StableCoin.increaseSupplyWithDeposit: Zero value");\n', '        require(_deposit <= _value, "StableCoin.increaseSupplyWithDeposit: Insufficient deposit");\n', '\n', '        totalSupply = totalSupply.add(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        freezeWithPurposeCode(_to, _deposit, encodePacked("InitialDeposit"));\n', '        emit Transfer(address(0), _to, _value.sub(_deposit));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease total supply (burn) from an address that gave allowance\n', '     *\n', '     * @param _value The amount of tokens to be burn\n', "     * @param _from The address's token will be burn\n", '     */\n', '    function decreaseSupply(uint256 _value, address _from) external\n', '        onlyOwner\n', '        onlyActive(_from)\n', '        returns (bool)\n', '    {\n', '        require(0 < _value, "StableCoin.decreaseSupply: Zero value");\n', '        require(_value <= balances[_from], "StableCoin.decreaseSupply: Insufficient fund");\n', '        require(_value <= allowed[_from][address(0)], "StableCoin.decreaseSupply: Insufficient allowance");\n', '\n', '        totalSupply = totalSupply.sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][address(0)] = allowed[_from][address(0)].sub(_value);\n', '        emit Transfer(_from, address(0), _value);\n', '        return true;\n', '    }\n', '\t\n', '    /**\n', '    * @dev Freeze holder balance\n', '    *\n', '    * @param _from The address which will be freeze\n', '    * @param _value The amount of tokens to be freeze\n', '    */\n', '    function freeze(address _from, uint256 _value) external\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        require(_value <= balances[_from], "StableCoin.freeze: Insufficient fund");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        freezeOf[_from] = freezeOf[_from].add(_value);\n', '        freezes[_from][FREEZE_CODE_DEFAULT] = freezes[_from][FREEZE_CODE_DEFAULT].add(_value);\n', '        emit Freeze(_from, _value);\n', '        emit FreezeWithPurpose(_from, _value, FREEZE_CODE_DEFAULT);\n', '        return true;\n', '    }\n', '\t\n', '    /**\n', '    * @dev Freeze holder balance with purpose code\n', '    *\n', '    * @param _from The address which will be freeze\n', '    * @param _value The amount of tokens to be freeze\n', '    * @param _purpose The purpose of freeze\n', '    */\n', '    function freezeWithPurpose(address _from, uint256 _value, string calldata _purpose) external\n', '        returns (bool)\n', '    {\n', '        return freezeWithPurposeCode(_from, _value, encodePacked(_purpose));\n', '    }\n', '\t\n', '    /**\n', '    * @dev Freeze holder balance with purpose code\n', '    *\n', '    * @param _from The address which will be freeze\n', '    * @param _value The amount of tokens to be freeze\n', '    * @param _purposeCode The purpose code of freeze\n', '    */\n', '    function freezeWithPurposeCode(address _from, uint256 _value, bytes32 _purposeCode) public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        require(_value <= balances[_from], "StableCoin.freezeWithPurposeCode: Insufficient fund");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        freezeOf[_from] = freezeOf[_from].add(_value);\n', '        freezes[_from][_purposeCode] = freezes[_from][_purposeCode].add(_value);\n', '        emit Freeze(_from, _value);\n', '        emit FreezeWithPurpose(_from, _value, _purposeCode);\n', '        return true;\n', '    }\n', '\t\n', '    /**\n', '    * @dev Unfreeze holder balance\n', '    *\n', '    * @param _from The address which will be unfreeze\n', '    * @param _value The amount of tokens to be unfreeze\n', '    */\n', '    function unfreeze(address _from, uint256 _value) external\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        require(_value <= freezes[_from][FREEZE_CODE_DEFAULT], "StableCoin.unfreeze: Insufficient fund");\n', '\n', '        freezeOf[_from] = freezeOf[_from].sub(_value);\n', '        freezes[_from][FREEZE_CODE_DEFAULT] = freezes[_from][FREEZE_CODE_DEFAULT].sub(_value);\n', '        balances[_from] = balances[_from].add(_value);\n', '        emit Unfreeze(_from, _value);\n', '        emit UnfreezeWithPurpose(_from, _value, FREEZE_CODE_DEFAULT);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Unfreeze holder balance with purpose code\n', '    *\n', '    * @param _from The address which will be unfreeze\n', '    * @param _value The amount of tokens to be unfreeze\n', '    * @param _purpose The purpose of unfreeze\n', '    */\n', '    function unfreezeWithPurpose(address _from, uint256 _value, string calldata _purpose) external\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        return unfreezeWithPurposeCode(_from, _value, encodePacked(_purpose));\n', '    }\n', '\n', '    /**\n', '    * @dev Unfreeze holder balance with purpose code\n', '    *\n', '    * @param _from The address which will be unfreeze\n', '    * @param _value The amount of tokens to be unfreeze\n', '    * @param _purposeCode The purpose code of unfreeze\n', '    */\n', '    function unfreezeWithPurposeCode(address _from, uint256 _value, bytes32 _purposeCode) public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        require(_value <= freezes[_from][_purposeCode], "StableCoin.unfreezeWithPurposeCode: Insufficient fund");\n', '\n', '        freezeOf[_from] = freezeOf[_from].sub(_value);\n', '        freezes[_from][_purposeCode] = freezes[_from][_purposeCode].sub(_value);\n', '        balances[_from] = balances[_from].add(_value);\n', '        emit Unfreeze(_from, _value);\n', '        emit UnfreezeWithPurpose(_from, _value, _purposeCode);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allocate allowance and perform contract call\n', '     *\n', '     * @param _spender The spender address\n', '     * @param _value The allowance value\n', '     * @param _extraData The function call data\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData) external\n', '        isUsable\n', '        returns (bool)\n', '    {\n', '        // Give allowance to spender (previous approved allowances will be clear)\n', '        approve(_spender, _value);\n', '\n', '        ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);\n', '        return true;\n', '    }\n', '\n', '    function encodePacked(string memory s) internal pure\n', '        returns (bytes32)\n', '    {\n', '        return keccak256(abi.encodePacked(s));\n', '    }\n', '\n', '}']