['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     **/\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '     * Integer division of two numbers, truncating the quotient.\n', '     **/\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '    \n', '    /**\n', '     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     **/\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    /**\n', '     * Adds two numbers, throws on overflow.\n', '     **/\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * Ownable\n', ' * The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' **/\n', ' \n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '     **/\n', '   constructor() public {\n', '      owner = msg.sender;\n', '    }\n', '    \n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     **/\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '    \n', '    /**\n', '     * Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     **/\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '      require(newOwner != address(0));\n', '      emit OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic interface\n', ' * @dev Basic ERC20 interface\n', ' **/\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' **/\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' **/\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) balances;\n', '    uint256 totalSupply_;\n', '    \n', '    /**\n', '     * @dev total number of tokens in existence\n', '     **/\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '    \n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     **/\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     **/\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     **/\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '    \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     **/\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     **/\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     **/\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     **/\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Configurable\n', ' * Configurable varriables of the contract\n', ' **/\n', 'contract Configurable {\n', '    uint256 public constant cap = 100000000*10**18;\n', '    uint256 public constant basePrice = 1500*10**18; // tokens per 1 ether\n', '    uint256 public tokensSold = 0;\n', '    \n', '    uint256 public constant tokenReserve = 20000000*10**18;\n', '    uint256 public remainingTokens = 0;\n', '}\n', '\n', '/**\n', ' * @title CrowdsaleToken \n', ' * @dev Contract to preform crowd sale with token\n', ' **/\n', 'contract CrowdsaleToken is StandardToken, Configurable, Ownable {\n', '    /**\n', '     * @dev enum of current crowd sale state\n', '     **/\n', '     enum Stages {\n', '        none,\n', '        icoStart, \n', '        icoEnd\n', '    }\n', '    \n', '    Stages currentStage;\n', '  \n', '    /**\n', '     * @dev constructor of CrowdsaleToken\n', '     **/\n', '    constructor() public {\n', '        currentStage = Stages.none;\n', '        balances[owner] = balances[owner].add(tokenReserve);\n', '        totalSupply_ = totalSupply_.add(tokenReserve);\n', '        remainingTokens = cap;\n', '        emit Transfer(address(this), owner, tokenReserve);\n', '    }\n', '    \n', '    /**\n', '     * fallback function to send ether to for Crowd sale\n', '     **/\n', '    function () public payable {\n', '        require(currentStage == Stages.icoStart);\n', '        require(msg.value > 0);\n', '        require(remainingTokens > 0);\n', '        \n', '        \n', '        uint256 weiAmount = msg.value; // Calculate tokens to sell\n', '        uint256 tokens = weiAmount.mul(basePrice).div(1 ether);\n', '        uint256 returnWei = 0;\n', '        \n', '        if(tokensSold.add(tokens) > cap){\n', '            uint256 newTokens = cap.sub(tokensSold);\n', '            uint256 newWei = newTokens.div(basePrice).mul(1 ether);\n', '            returnWei = weiAmount.sub(newWei);\n', '            weiAmount = newWei;\n', '            tokens = newTokens;\n', '        }\n', '        \n', '        tokensSold = tokensSold.add(tokens); // Increment raised amount\n', '        remainingTokens = cap.sub(tokensSold);\n', '        if(returnWei > 0){\n', '            msg.sender.transfer(returnWei);\n', '            emit Transfer(address(this), msg.sender, returnWei);\n', '        }\n', '        \n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        emit Transfer(address(this), msg.sender, tokens);\n', '        totalSupply_ = totalSupply_.add(tokens);\n', '        owner.transfer(weiAmount);// Send money to owner\n', '    }\n', '    \n', '\n', '    /**\n', '     * @dev startIco starts the public ICO\n', '     **/\n', '    function startIco() public onlyOwner {\n', '        require(currentStage != Stages.icoEnd);\n', '        currentStage = Stages.icoStart;\n', '    }\n', '    \n', '\n', '    /**\n', '     * @dev endIco closes down the ICO \n', '     **/\n', '    function endIco() internal {\n', '        currentStage = Stages.icoEnd;\n', '        // Transfer any remaining tokens\n', '        if(remainingTokens > 0)\n', '            balances[owner] = balances[owner].add(remainingTokens);\n', '        // transfer any remaining ETH balance in the contract to the owner\n', '        owner.transfer(address(this).balance); \n', '    }\n', '\n', '    /**\n', '     * @dev finalizeIco closes down the ICO and sets needed varriables\n', '     **/\n', '    function finalizeIco() public onlyOwner {\n', '        require(currentStage != Stages.icoEnd);\n', '        endIco();\n', '    }\n', '    \n', '}\n', '\n', '/**\n', ' * @title DalyVentureFund1\n', ' * @dev Contract to create the DV1\n', ' **/\n', 'contract DalyVentures_FundI is CrowdsaleToken {\n', '    string public constant name = "DV Fund I";\n', '    string public constant symbol = "DV1";\n', '    uint32 public constant decimals = 18;\n', '}']