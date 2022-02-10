['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', 'contract MintableToken is PausableToken {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract TokenImpl is MintableToken {\n', '    string public name;\n', '    string public symbol;\n', '\n', '    // how many token units a buyer gets per ether\n', '    uint256 public rate;\n', '\n', '    uint256 public decimals = 5;\n', '    uint256 private decimal_num = 100000;\n', '\n', '    // the target token\n', '    ERC20Basic public targetToken;\n', '\n', '    uint256 public exchangedNum;\n', '\n', '    event Exchanged(address _owner, uint256 _value);\n', '\n', '    function TokenImpl(string _name, string _symbol, uint256 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        decimal_num = 10 ** decimals;\n', '        paused = true;\n', '    }\n', '    /**\n', '      * @dev exchange tokens of _exchanger.\n', '      */\n', '    function exchange(address _exchanger, uint256 _value) internal {\n', '        require(canExchange());\n', '        uint256 _tokens = (_value.mul(rate)).div(decimal_num);\n', '        targetToken.transfer(_exchanger, _tokens);\n', '        exchangedNum = exchangedNum.add(_value);\n', '        Exchanged(_exchanger, _tokens);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        if (_to == address(this) || _to == owner) {\n', '            exchange(msg.sender, _value);\n', '        }\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if (_to == address(this) || _to == owner) {\n', '            exchange(msg.sender, _value);\n', '        }\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function balanceOfTarget(address _owner) public view returns (uint256 targetBalance) {\n', '        if (targetToken != address(0)) {\n', '            return targetToken.balanceOf(_owner);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function canExchangeNum() public view returns (uint256) {\n', '        if (canExchange()) {\n', '            uint256 _tokens = targetToken.balanceOf(this);\n', '            return (decimal_num.mul(_tokens)).div(rate);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function updateTargetToken(address _target, uint256 _rate) onlyOwner public {\n', '        rate = _rate;\n', '        targetToken = ERC20Basic(_target);\n', '    }\n', '\n', '    function canExchange() public view returns (bool) {\n', '        return targetToken != address(0) && rate > 0;\n', '    }\n', '\n', '\n', '}\n', '\n', 'contract Crowdsale is Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    string public projectName;\n', '\n', '    string public tokenName;\n', '    string public tokenSymbol;\n', '\n', '    // how many token units a buyer gets per ether\n', '    uint256 public rate;\n', '\n', '    // amount of raised money in wei, decimals is 5\n', '    uint256 public ethRaised;\n', '    uint256 public decimals = 5;\n', '    uint256 private decimal_num = 100000;\n', '\n', '    // cap of money in wei\n', '    uint256 public cap;\n', '\n', '    // The token being sold\n', '    TokenImpl public token;\n', '\n', '    // the target token\n', '    ERC20Basic public targetToken;\n', '\n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value);\n', '    event IncreaseCap(uint256 cap);\n', '    event DecreaseCap(uint256 cap);\n', '    event TransferTargetToken(address owner, uint256 value);\n', '\n', '\n', '    function Crowdsale(string _projectName, string _tokenName, string _tokenSymbol,\n', '        uint256 _cap) public {\n', '        require(_cap > 0);\n', '        projectName = _projectName;\n', '        tokenName = _tokenName;\n', '        tokenSymbol = _tokenSymbol;\n', '        cap = _cap.mul(decimal_num);\n', '        token = createTokenContract();\n', '    }\n', '\n', '    function newCrowdSale(string _projectName, string _tokenName,\n', '        string _tokenSymbol, uint256 _cap) onlyOwner public {\n', '        require(_cap > 0);\n', '        projectName = _projectName;\n', '        tokenName = _tokenName;\n', '        tokenSymbol = _tokenSymbol;\n', '        cap = _cap.mul(decimal_num);\n', '        ethRaised = 0;\n', '        token.transferOwnership(owner);\n', '        token = createTokenContract();\n', '        rate = 0;\n', '        targetToken = ERC20Basic(0);\n', '    }\n', '\n', '    function createTokenContract() internal returns (TokenImpl) {\n', '        return new TokenImpl(tokenName, tokenSymbol, decimals);\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) whenNotPaused public payable {\n', '        require(beneficiary != address(0));\n', '        require(msg.value >= (0.00001 ether));\n', '\n', '        uint256 ethAmount = (msg.value.mul(decimal_num)).div(1 ether);\n', '\n', '        // update state\n', '        ethRaised = ethRaised.add(ethAmount);\n', '        require(ethRaised <= cap);\n', '\n', '        token.mint(beneficiary, ethAmount);\n', '        TokenPurchase(msg.sender, beneficiary, ethAmount);\n', '\n', '        forwardFunds();\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds() internal {\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    // increase the amount of eth\n', '    function increaseCap(uint256 _cap_inc) onlyOwner public {\n', '        require(_cap_inc > 0);\n', '        cap = cap.add(_cap_inc.mul(decimal_num));\n', '        IncreaseCap(cap);\n', '    }\n', '\n', '    function decreaseCap(uint256 _cap_dec) onlyOwner public {\n', '        require(_cap_dec > 0);\n', '        uint256 cap_dec = _cap_dec.mul(decimal_num);\n', '        if (cap_dec >= cap) {\n', '            cap = ethRaised;\n', '        } else {\n', '            cap = cap.sub(cap_dec);\n', '            if (cap <= ethRaised) {\n', '                cap = ethRaised;\n', '            }\n', '        }\n', '        DecreaseCap(cap);\n', '    }\n', '\n', '    function saleRatio() public view returns (uint256 ratio) {\n', '        if (cap == 0) {\n', '            return 0;\n', '        } else {\n', '            return ethRaised.mul(10000).div(cap);\n', '        }\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return token.balanceOf(_owner);\n', '    }\n', '\n', '    function balanceOfTarget(address _owner) public view returns (uint256 targetBalance) {\n', '        return token.balanceOfTarget(_owner);\n', '    }\n', '\n', '    function canExchangeNum() public view returns (uint256) {\n', '        return token.canExchangeNum();\n', '    }\n', '\n', '    function updateTargetToken(address _target, uint256 _rate) onlyOwner public {\n', '        rate = _rate;\n', '        targetToken = ERC20Basic(_target);\n', '        token.updateTargetToken(_target, _rate);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to transfer the target token to _owner from this contact\n', '     */\n', '    function transferTargetToken(address _owner, uint256 _value) onlyOwner public returns (bool) {\n', '        if (targetToken != address(0)) {\n', '            TransferTargetToken(_owner, _value);\n', '            return targetToken.transfer(_owner, _value);\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pauseToken() onlyOwner public {\n', '        token.pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpauseToken() onlyOwner public {\n', '        token.unpause();\n', '    }\n', '\n', '}']