['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        // require(_b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = _a / _b;\n', "        // require(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to relinquish control of the contract.\n', '    * @notice Renouncing to ownership will leave the contract without an owner.\n', '    * It will not be possible to call the functions with the `onlyOwner`\n', '    * modifier anymore.\n', '    */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfers control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is not paused.\n', '    */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is paused.\n', '    */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title ERC20 interface\n', '* @dev see https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address _who) public view returns (uint256);\n', '\n', '    function allowance(address _owner, address _spender)\n', '        public view returns (uint256);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public returns (bool);\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '/**\n', '* @title Standard ERC20 token\n', '*\n', '* @dev Implementation of the basic standard token.\n', '* https://github.com/ethereum/EIPs/issues/20\n', '* Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '*/\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', '* @title Pausable token\n', '* @dev StandardToken modified with pausable transfers.\n', '**/\n', 'contract PausableERC20Token is StandardToken, Pausable {\n', '\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(\n', '        address _spender,\n', '        uint256 _value\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint _addedValue\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool success)\n', '    {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint _subtractedValue\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool success)\n', '    {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title Burnable Pausable Token\n', '* @dev Pausable Token that can be irreversibly burned (destroyed).\n', '*/\n', 'contract BurnablePausableERC20Token is PausableERC20Token {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowedBurn;\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    event ApprovalBurn(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    function allowanceBurn(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowedBurn[_owner][_spender];\n', '    }\n', '\n', '    function approveBurn(address _spender, uint256 _value)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        allowedBurn[msg.sender][_spender] = _value;\n', '        emit ApprovalBurn(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(\n', '        uint256 _value\n', '    ) \n', '        public\n', '        whenNotPaused\n', '    {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _value uint256 The amount of token to be burned\n', '    */\n', '    function burnFrom(\n', '        address _from, \n', '        uint256 _value\n', '    ) \n', '        public \n', '        whenNotPaused\n', '    {\n', '        require(_value <= allowedBurn[_from][msg.sender]);\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        // this function needs to emit an event with the updated approval.\n', '        allowedBurn[_from][msg.sender] = allowedBurn[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '\n', '    function _burn(\n', '        address _who, \n', '        uint256 _value\n', '    ) \n', '        internal \n', '        whenNotPaused\n', '    {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '\n', '    function increaseBurnApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        allowedBurn[msg.sender][_spender] = (\n', '        allowedBurn[msg.sender][_spender].add(_addedValue));\n', '        emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseBurnApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = allowedBurn[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowedBurn[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowedBurn[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract FreezableBurnablePausableERC20Token is BurnablePausableERC20Token {\n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function freezeAccount(\n', '        address target,\n', '        bool freeze\n', '    )\n', '        public\n', '        onlyOwner\n', '    {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        require(!frozenAccount[msg.sender], "Sender account freezed");\n', '        require(!frozenAccount[_to], "Receiver account freezed");\n', '\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        require(!frozenAccount[msg.sender], "Spender account freezed");\n', '        require(!frozenAccount[_from], "Sender account freezed");\n', '        require(!frozenAccount[_to], "Receiver account freezed");\n', '\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function burn(\n', '        uint256 _value\n', '    ) \n', '        public\n', '        whenNotPaused\n', '    {\n', '        require(!frozenAccount[msg.sender], "Sender account freezed");\n', '\n', '        return super.burn(_value);\n', '    }\n', '\n', '    function burnFrom(\n', '        address _from, \n', '        uint256 _value\n', '    ) \n', '        public \n', '        whenNotPaused\n', '    {\n', '        require(!frozenAccount[msg.sender], "Spender account freezed");\n', '        require(!frozenAccount[_from], "Sender account freezed");\n', '\n', '        return super.burnFrom(_from, _value);\n', '    }\n', '}\n', '\n', '/**\n', '* @title LLB\n', '* @dev Token that is ERC20 compatible, Pausableb, Burnable, Ownable with SafeMath.\n', '*/\n', 'contract LLB is FreezableBurnablePausableERC20Token {\n', '\n', '    /** Token Setting: You are free to change any of these\n', '    * @param name string The name of your token (can be not unique)\n', '    * @param symbol string The symbol of your token (can be not unique, can be more than three characters)\n', '    * @param decimals uint8 The accuracy decimals of your token (conventionally be 18)\n', '    * Read this to choose decimals: https://ethereum.stackexchange.com/questions/38704/why-most-erc-20-tokens-have-18-decimals\n', '    * @param INITIAL_SUPPLY uint256 The total supply of your token. Example default to be "10000". Change as you wish.\n', '    **/\n', '    string public constant name = "LLB Token";\n', '    string public constant symbol = "LLB";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));\n', '\n', '    /**\n', '    * @dev Constructor that gives msg.sender all of existing tokens.\n', '    * Literally put all the issued money in your pocket\n', '    */\n', '    constructor() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);\n', '    }\n', '}']