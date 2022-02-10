['pragma solidity ^0.4.24;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = _a / _b;\n', "        // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address _who) public view returns (uint256);\n', '\n', '    function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '    function approve(address _spender, uint256 _value)\n', '    public returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '\n', '\n', 'contract TimberCoin is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) public balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '\n', '    uint256 private totalSupply_ = 1750000 * 10**2;\n', '\n', '    string public constant name = "TimberCoin";\n', '    string public constant symbol = "TMB";\n', '    uint8 public constant decimals = 2;\n', '\n', '\n', '    constructor() public {\n', '        balances[msg.sender] = totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '    public\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != address(0));\n', '\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param _account The account whose tokens will be burnt.\n', '     * @param _amount The amount that will be burnt.\n', '     */\n', '    function _burn(address _account, uint256 _amount) internal {\n', '        require(_account != 0);\n', '        require(_amount <= balances[_account]);\n', '\n', '        totalSupply_ = totalSupply_.sub(_amount);\n', '        balances[_account] = balances[_account].sub(_amount);\n', '        emit Transfer(_account, address(0), _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal _burn function.\n', '     * @param _account The account whose tokens will be burnt.\n', '     * @param _amount The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address _account, uint256 _amount) internal {\n', '        require(_amount <= allowed[_account][msg.sender]);\n', '\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        // this function needs to emit an event with the updated approval.\n', '        allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);\n', '        _burn(_account, _amount);\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract CrowdsaleTMB is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address public multisig;\n', '\n', '    TimberCoin public token;\n', '\n', '    uint rate = 100 * 10**2;\n', '\n', '    bool public isPaused;\n', '\n', '    constructor(address _TimberCoin) public {\n', '        token = TimberCoin(_TimberCoin);\n', '        multisig = 0xdB5964B7Fe29FFE675ce2e6C30cFbe8F8279E711;\n', '    }\n', '\n', '    function changeMultisig(address _newMultisig) external onlyOwner {\n', '        require(_newMultisig != 0);\n', '        multisig = _newMultisig;\n', '    }\n', '\n', '    function pause() public onlyOwner {\n', '        isPaused = true;\n', '    }\n', '\n', '    function unpause() external onlyOwner {\n', '        isPaused = false;\n', '    }\n', '\n', '    function getCurrentRate() internal view returns(uint) {\n', '        if (block.timestamp < 1537747200) {\n', '            revert();\n', '        }   else if (block.timestamp < 1538352000) {\n', '            return rate.add(rate.mul(7).div(10));\n', '        }   else if (block.timestamp < 1538956800) {\n', '            return rate.add(rate.mul(3).div(5));\n', '        }   else if (block.timestamp < 1539561600) {\n', '            return rate.add(rate.div(2));\n', '        }   else if (block.timestamp < 1540166400) {\n', '            return rate.add(rate.mul(2).div(5));\n', '        }   else if (block.timestamp < 1540771200) {\n', '            return rate.add(rate.mul(3).div(10));\n', '        }   else if (block.timestamp < 1541030400) {\n', '            return rate.add(rate.div(4));\n', '        }   else if (block.timestamp < 1541635200) {\n', '            return rate.add(rate.div(5));\n', '        }   else if (block.timestamp < 1542240000) {\n', '            return rate.add(rate.mul(3).div(20));\n', '        }   else if (block.timestamp < 1542844800) {\n', '            return rate.add(rate.div(10));\n', '        }   else if (block.timestamp < 1543622400) {\n', '            return rate.add(rate.div(20));\n', '        }   else {\n', '            return rate;\n', '        }\n', '    }\n', '\n', '    function() external payable {\n', '        buyTokens();\n', '    }\n', '\n', '    function buyTokens() public payable {\n', '        require(msg.value >= 10000000000000000);\n', '\n', '        uint256 amount = msg.value.mul(getCurrentRate()).div(1 ether);\n', '        uint256 balance = token.balanceOf(this);\n', '\n', '        if (amount > balance) {\n', '            uint256 cash = balance.mul(1 ether).div(getCurrentRate());\n', '            uint256 cashBack = msg.value.sub(cash);\n', '            multisig.transfer(cash);\n', '            msg.sender.transfer(cashBack);\n', '            token.transfer(msg.sender, balance);\n', '            return;\n', '        }\n', '        multisig.transfer(msg.value);\n', '        token.transfer(msg.sender, amount);\n', '    }\n', '\n', '    function sendTokens(address _recipient, uint _amount) external onlyOwner {\n', '        token.transfer(_recipient, _amount);\n', '    }\n', '\n', '    function finalizeICO(address _owner) external onlyOwner {\n', '        require(_owner != address(0));\n', '        uint balance = token.balanceOf(this);\n', '        token.transfer(_owner, balance);\n', '        isPaused = true;\n', '    }\n', '\n', '    function getMyBalanceTMB() external view returns(uint256) {\n', '        return token.balanceOf(msg.sender);\n', '    }\n', '}']