['pragma solidity ^0.4.24;\n', '\n', '/**xxp 校验防止溢出情况\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20Basic {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    modifier hasMintPermission() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(\n', '        address _to,\n', '        uint256 _amount\n', '    )\n', '        hasMintPermission\n', '        canMint\n', '        public\n', '        returns (bool)\n', '    {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Controlled is Ownable{\n', '\n', '    constructor() public {\n', '        setExclude(msg.sender);\n', '    }\n', '\n', '    // Flag that determines if the token is transferable or not.\n', '    bool public transferEnabled = true;\n', '\n', '    // flag that makes locked address effect\n', '    bool public plockFlag=true;\n', '    mapping(address => bool) locked;\n', '    mapping(address => bool) exclude;\n', '\n', '    // 控制全局全局锁\n', '    function enableTransfer(bool _enable) public onlyOwner{\n', '        transferEnabled = _enable;\n', '    }\n', '\n', '    // 控制个人锁功能\n', '    function enableLockFlag(bool _enable) public onlyOwner returns (bool success){\n', '        plockFlag = _enable;\n', '        return true;\n', '    }\n', '\n', '    function addLock(address _addr) public onlyOwner returns (bool success){\n', '        require(_addr!=msg.sender);\n', '        locked[_addr] = true;\n', '        return true;\n', '    }\n', '\n', '    function setExclude(address _addr) public onlyOwner returns (bool success){\n', '        exclude[_addr] = true;\n', '        return true;\n', '    }\n', '\n', '    function removeLock(address _addr) public onlyOwner returns (bool success){\n', '        locked[_addr] = false;\n', '        return true;\n', '    }\n', '\n', '    modifier transferAllowed(address _addr) {\n', '        if (!exclude[_addr]) {\n', '            // flase抛异常，并扣除gas消耗\n', '            assert(transferEnabled);\n', '            if(plockFlag){\n', '                assert(!locked[_addr]);\n', '            }\n', '        }\n', '        \n', '        _;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' *\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', '\n', 'contract PausableToken is StandardToken, Controlled {\n', '\n', '    function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public transferAllowed(msg.sender) returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '}\n', '\n', '/*\n', ' * @title AGC\n', ' */\n', 'contract AGC is BurnableToken, MintableToken, PausableToken {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    // decimals is the strongly suggested default, avoid changing it\n', '    uint8 public decimals;\n', '\n', '    constructor() public {\n', '        name = "AgamChain";\n', '        symbol = "AGC";\n', '        decimals = 18;\n', '        totalSupply_ = 100000000 * 10 ** uint256(decimals);\n', '\n', '        // Allocate initial balance to the owner\n', '        balances[msg.sender] = totalSupply_;\n', '    }\n', '\n', '    // transfer balance to owner\n', '    function withdrawEther() onlyOwner public {\n', '        address addr = this;\n', '        owner.transfer(addr.balance);\n', '    }\n', '\n', '    // can accept ether\n', '    function() payable public { }\n', '\n', '    // Allocate tokens to the users\n', '    // @param _owners The owners list of the token\n', '    // @param _values The value list of the token\n', '    function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {\n', '\n', '        require(_owners.length == _values.length, "data length mismatch");\n', '        address from = msg.sender;\n', '\n', '        for(uint256 i = 0; i < _owners.length ; i++){\n', '            address to = _owners[i];\n', '            uint256 value = _values[i];\n', '            require(value <= balances[from]);\n', '\n', '            balances[to] = balances[to].add(value);\n', '            balances[from] = balances[from].sub(value);\n', '            emit Transfer(from, to, value);\n', '        }\n', '    }\n', '}']