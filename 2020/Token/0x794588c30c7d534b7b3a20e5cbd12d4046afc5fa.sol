['pragma solidity 0.5.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balanceOf(msg.sender));\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of. \n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        require(balanceOf(_from) >= _value);\n', '        require(balances[_to].add(_value) > balances[_to]); // Check for overflows\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until \n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is StandardToken {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    address public founder;\n', '    \n', '    /**\n', '    * @dev modifier to allow actions only when the contract IS paused\n', '    */\n', '    modifier whenNotPaused() {\n', '        require(!paused || msg.sender == founder);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev modifier to allow actions only when the contract IS NOT paused\n', '    */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', 'contract PausableToken is Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    //The functions below surve no real purpose. Even if one were to approve another to spend\n', '    //tokens on their behalf, those tokens will still only be transferable when the token contract\n', '    //is not paused.\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', 'contract CFS is PausableToken {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    /**\n', '    * @dev Constructor that gives the founder all of the existing tokens.\n', '    */\n', '    constructor() public {\n', '        name = "Crowd Funding Society";\n', '        symbol = "CFS";\n', '        decimals = 18;\n', '        totalSupply = 210000000*1000000000000000000;\n', '        founder = msg.sender;\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '    \n', '    /** @dev Fires on every freeze of tokens\n', '     *  @param _owner address The owner address of frozen tokens.\n', '     *  @param amount uint256 The amount of tokens frozen\n', '     */\n', '    event TokenFreezeEvent(address indexed _owner, uint256 amount);\n', '\n', '    /** @dev Fires on every unfreeze of tokens\n', '     *  @param _owner address The owner address of unfrozen tokens.\n', '     *  @param amount uint256 The amount of tokens unfrozen\n', '     */\n', '    event TokenUnfreezeEvent(address indexed _owner, uint256 amount);\n', '    event TokensBurned(address indexed _owner, uint256 _tokens);\n', '\n', '    \n', '    mapping(address => uint256) internal frozenTokenBalances;\n', '\n', '    function freezeTokens(address _owner, uint256 _value) public onlyOwner {\n', '        require(_value <= balanceOf(_owner));\n', '        uint256 oldFrozenBalance = getFrozenBalance(_owner);\n', '        uint256 newFrozenBalance = oldFrozenBalance.add(_value);\n', '        setFrozenBalance(_owner,newFrozenBalance);\n', '        emit TokenFreezeEvent(_owner,_value);\n', '    }\n', '    \n', '    function unfreezeTokens(address _owner, uint256 _value) public onlyOwner {\n', '        require(_value <= getFrozenBalance(_owner));\n', '        uint256 oldFrozenBalance = getFrozenBalance(_owner);\n', '        uint256 newFrozenBalance = oldFrozenBalance.sub(_value);\n', '        setFrozenBalance(_owner,newFrozenBalance);\n', '        emit TokenUnfreezeEvent(_owner,_value);\n', '    }\n', '    \n', '    \n', '    function setFrozenBalance(address _owner, uint256 _newValue) internal {\n', '        frozenTokenBalances[_owner]=_newValue;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns(uint256)  {\n', '        return getTotalBalance(_owner).sub(getFrozenBalance(_owner));\n', '    }\n', '\n', '    function getTotalBalance(address _owner) view public returns(uint256) {\n', '        return balances[_owner];   \n', '    }\n', '    /**\n', '     * @dev Gets the amount of tokens which belong to the specified address BUT are frozen now.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount of frozen tokens owned by the passed address.\n', '    */\n', '\n', '    function getFrozenBalance(address _owner) view public returns(uint256) {\n', '        return frozenTokenBalances[_owner];   \n', '    }\n', '    \n', '    /*\n', '    * @dev Token burn function\n', '    * @param _tokens uint256 amount of tokens to burn\n', '    */\n', '    function burnTokens(uint256 _tokens) public onlyOwner {\n', '        require(balanceOf(msg.sender) >= _tokens);\n', '        balances[msg.sender] = balances[msg.sender].sub(_tokens);\n', '        totalSupply = totalSupply.sub(_tokens);\n', '        emit TokensBurned(msg.sender, _tokens);\n', '    }\n', '    function destroy(address payable _benefitiary) external onlyOwner{\n', '        selfdestruct(_benefitiary);\n', '    }\n', '}']