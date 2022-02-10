['pragma solidity ^ 0.4.19;\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '  * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '  * account.\n', '  */\n', '    function Ownable()public {\n', '        owner = msg.sender;\n', '    }\n', '    /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    /**\n', '  * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '  * @param newOwner The address to transfer ownership to.\n', '  */\n', '    function transferOwnership(address newOwner)public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b);  There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is Ownable {\n', '\n', '  function Destructible() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Destructible {\n', '    event Pause();\n', '    event Unpause();\n', '    bool public paused = false;\n', '    /**\n', '  * @dev Modifier to make a function callable only when the contract is not paused.\n', '  */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '    /**\n', '  * @dev Modifier to make a function callable only when the contract is paused.\n', '  */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '    /**\n', '  * @dev called by the owner to pause, triggers stopped state\n', '  */\n', '    function pause()onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '    /**\n', '  * @dev called by the owner to unpause, returns to normal state\n', '  */\n', '    function unpause()onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    uint256 public completeRemainingTokens;\n', '    function balanceOf(address who)public view returns(uint256);\n', '    function transfer(address to, uint256 value)public returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic,\n', 'Pausable {\n', '    uint256 startPreSale; uint256 endPreSale; uint256 startSale; \n', '    uint256 endSale; \n', '    using SafeMath for uint256; mapping(address => uint256)balances; uint256 preICOReserveTokens; uint256 icoReserveTokens; \n', '    address businessReserveAddress; uint256 public timeLock = 1586217600; //7 April 2020 locked\n', '    uint256 public incentiveTokensLimit;\n', '    modifier checkAdditionalTokenLock(uint256 value) {\n', '\n', '        if (msg.sender == businessReserveAddress) {\n', '            \n', '            if ((now<endSale) ||(now < timeLock &&value>incentiveTokensLimit)) {\n', '                revert();\n', '            } else {\n', '                _;\n', '            }\n', '        } else {\n', '            _;\n', '        }\n', '\n', '    }\n', '    \n', '    function updateTimeLock(uint256 _timeLock) external onlyOwner {\n', '        timeLock = _timeLock;\n', '    }\n', '    function updateBusinessReserveAddress(address _businessAddress) external onlyOwner {\n', '        businessReserveAddress =_businessAddress;\n', '    }\n', '    \n', '    function updateIncentiveTokenLimit(uint256 _incentiveTokens) external onlyOwner {\n', '      incentiveTokensLimit = _incentiveTokens;\n', '   }    \n', '    /**\n', ' * @dev transfer token for a specified address\n', ' * @param _to The address to transfer to.\n', ' * @param _value The amount to be transferred.\n', ' */\n', '    function transfer(address _to, uint256 _value)public whenNotPaused checkAdditionalTokenLock(_value) returns(\n', '        bool\n', '    ) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', ' * @dev Gets the balance of the specified address.\n', ' * @param _owner The address to query the the balance of.\n', ' * @return An uint256 representing the amount owned by the passed address.\n', ' */\n', '    function balanceOf(address _owner)public constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender)public view returns(uint256);\n', '    function transferFrom(address from, address to, uint256 value)public returns(\n', '        bool\n', '    );\n', '    function approve(address spender, uint256 value)public returns(bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '   * @dev Burns a all amount of tokens of address.\n', '   */\n', '    function burn()public {\n', '        uint256 _value = balances[msg.sender];\n', '        // no need to require value <= totalSupply, since that would imply the sender&#39;s\n', '        // balance is greater than the totalSupply, which *should* be an assertion\n', '        // failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0), _value);\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20,BurnableToken {\n', '    mapping(address => mapping(address => uint256))internal allowed;\n', '\n', '    /**\n', '  * @dev Transfer tokens from one address to another\n', '  * @param _from address The address which you want to send tokens from\n', '  * @param _to address The address which you want to transfer to\n', '  * @param _value uint256 the amount of tokens to be transferred\n', '  */\n', '    function transferFrom(address _from, address _to, uint256 _value)public whenNotPaused checkAdditionalTokenLock(_value) returns(\n', '        bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    /**\n', '  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '  *\n', '  * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '  * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '  * @param _spender The address which will spend the funds.\n', '  * @param _value The amount of tokens to be spent.\n', '  */\n', '    function approve(address _spender, uint256 _value)public checkAdditionalTokenLock(_value) returns(\n', '        bool\n', '    ) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    /**\n', '  * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '  * @param _owner address The address which owns the funds.\n', '  * @param _spender address The address which will spend the funds.\n', '  * @return A uint256 specifying the amount of tokens still available for the spender.\n', '  */\n', '    function allowance(address _owner, address _spender)public constant returns(\n', '        uint256 remaining\n', '    ) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    /**\n', '  * approve should be called when allowed[_spender] == 0. To increment\n', '  * allowed value is better to use this function to avoid 2 calls (and wait until\n', '  * the first transaction is mined)\n', '  * From MonolithDAO Token.sol\n', '  */\n', '    function increaseApproval(address _spender, uint _addedValue)public checkAdditionalTokenLock(_addedValue) returns(\n', '        bool success\n', '    ) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    function decreaseApproval(address _spender, uint _subtractedValue)public returns(\n', '        bool success\n', '    ) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', 'contract SMRTCoin is StandardToken {\n', '    string public constant name = "SMRT";\n', '    uint public constant decimals = 18;\n', '    string public constant symbol = "SMRT";\n', '    using SafeMath for uint256; uint256 public weiRaised = 0; address depositWalletAddress; \n', '    event Buy(address _from, uint256 _ethInWei, string userId); \n', '    \n', '    function SMRTCoin()public {\n', '        owner = msg.sender;\n', '        totalSupply = 600000000 * (10 ** decimals);\n', '        preICOReserveTokens = 90000000 * (10 ** decimals);\n', '        icoReserveTokens = 210000000 * (10 ** decimals);\n', '        depositWalletAddress = 0x85a98805C17701504C252eAAB99f60C7c204A785; //TODO change\n', '        businessReserveAddress = 0x73FEC20272a555Af1AEA4bF27D406683632c2a8c; \n', '        balances[owner] = totalSupply;\n', '        emit Transfer(address(0), owner, totalSupply);\n', '        startPreSale = now; //TODO update 1521900000 24 march 14 00 00 UTC\n', '        endPreSale = 1524319200; //21 April 14 00 00 utc\n', '        startSale = endPreSale + 1;\n', '        endSale = startSale + 30 days;\n', '    }\n', '    function ()public {\n', '        revert();\n', '    }\n', '    /**\n', '   * This will be called by adding data to represnet data.\n', '   */\n', '    function buy(string userId)public payable whenNotPaused {\n', '        require(msg.value > 0);\n', '        require(msg.sender != address(0));\n', '        weiRaised += msg.value;\n', '        forwardFunds();\n', '        emit Buy(msg.sender, msg.value, userId);\n', '    }\n', '    /**\n', '   * This function will called by only distributors to send tokens by calculating from offchain listners\n', '   */\n', '    function getBonustokens(uint256 tokens)internal returns(uint256 bonusTokens) {\n', '        require(now <= endSale);\n', '        uint256 bonus;\n', '        if (now <= endPreSale) {\n', '            bonus = 50;\n', '        } else if (now < startSale + 1 weeks) {\n', '            bonus = 10;\n', '        } else if (now < startSale + 2 weeks) {\n', '            bonus = 5;\n', '        }\n', '\n', '        bonusTokens = ((tokens / 100) * bonus);\n', '    }\n', '    function CrowdSale(address recieverAddress, uint256 tokens)public onlyOwner {\n', '        tokens =  tokens.add(getBonustokens(tokens));\n', '        uint256 tokenLimit = (tokens.mul(20)).div(100); //as 20 becuase its 10 percnet of total\n', '        incentiveTokensLimit  = incentiveTokensLimit.add(tokenLimit);\n', '        if (now <= endPreSale && preICOReserveTokens >= tokens) {\n', '            preICOReserveTokens = preICOReserveTokens.sub(tokens);\n', '            transfer(businessReserveAddress, tokens);\n', '            transfer(recieverAddress, tokens);\n', '        } else if (now < endSale && icoReserveTokens >= tokens) {\n', '            icoReserveTokens = icoReserveTokens.sub(tokens);\n', '            transfer(businessReserveAddress, tokens);\n', '            transfer(recieverAddress, tokens);\n', '        }\n', '        else{ \n', '            revert();\n', '        }\n', '    }\n', '    /**\n', '  * @dev Determines how ETH is stored/forwarded on purchases.\n', '  */\n', '    function forwardFunds()internal {\n', '        depositWalletAddress.transfer(msg.value);\n', '    }\n', '    function changeDepositWalletAddress(address newDepositWalletAddr)external onlyOwner {\n', '        require(newDepositWalletAddr != 0);\n', '        depositWalletAddress = newDepositWalletAddr;\n', '    }\n', '    function updateSaleTime(uint256 _startSale, uint256 _endSale)external onlyOwner {\n', '        startSale = _startSale;\n', '        endSale = _endSale;\n', '    }\n', '\n', ' \n', '\n', '}']
['pragma solidity ^ 0.4.19;\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '  * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '  * account.\n', '  */\n', '    function Ownable()public {\n', '        owner = msg.sender;\n', '    }\n', '    /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    /**\n', '  * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '  * @param newOwner The address to transfer ownership to.\n', '  */\n', '    function transferOwnership(address newOwner)public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b);  There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b)internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is Ownable {\n', '\n', '  function Destructible() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Destructible {\n', '    event Pause();\n', '    event Unpause();\n', '    bool public paused = false;\n', '    /**\n', '  * @dev Modifier to make a function callable only when the contract is not paused.\n', '  */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '    /**\n', '  * @dev Modifier to make a function callable only when the contract is paused.\n', '  */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '    /**\n', '  * @dev called by the owner to pause, triggers stopped state\n', '  */\n', '    function pause()onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '    /**\n', '  * @dev called by the owner to unpause, returns to normal state\n', '  */\n', '    function unpause()onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    uint256 public completeRemainingTokens;\n', '    function balanceOf(address who)public view returns(uint256);\n', '    function transfer(address to, uint256 value)public returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic,\n', 'Pausable {\n', '    uint256 startPreSale; uint256 endPreSale; uint256 startSale; \n', '    uint256 endSale; \n', '    using SafeMath for uint256; mapping(address => uint256)balances; uint256 preICOReserveTokens; uint256 icoReserveTokens; \n', '    address businessReserveAddress; uint256 public timeLock = 1586217600; //7 April 2020 locked\n', '    uint256 public incentiveTokensLimit;\n', '    modifier checkAdditionalTokenLock(uint256 value) {\n', '\n', '        if (msg.sender == businessReserveAddress) {\n', '            \n', '            if ((now<endSale) ||(now < timeLock &&value>incentiveTokensLimit)) {\n', '                revert();\n', '            } else {\n', '                _;\n', '            }\n', '        } else {\n', '            _;\n', '        }\n', '\n', '    }\n', '    \n', '    function updateTimeLock(uint256 _timeLock) external onlyOwner {\n', '        timeLock = _timeLock;\n', '    }\n', '    function updateBusinessReserveAddress(address _businessAddress) external onlyOwner {\n', '        businessReserveAddress =_businessAddress;\n', '    }\n', '    \n', '    function updateIncentiveTokenLimit(uint256 _incentiveTokens) external onlyOwner {\n', '      incentiveTokensLimit = _incentiveTokens;\n', '   }    \n', '    /**\n', ' * @dev transfer token for a specified address\n', ' * @param _to The address to transfer to.\n', ' * @param _value The amount to be transferred.\n', ' */\n', '    function transfer(address _to, uint256 _value)public whenNotPaused checkAdditionalTokenLock(_value) returns(\n', '        bool\n', '    ) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', ' * @dev Gets the balance of the specified address.\n', ' * @param _owner The address to query the the balance of.\n', ' * @return An uint256 representing the amount owned by the passed address.\n', ' */\n', '    function balanceOf(address _owner)public constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender)public view returns(uint256);\n', '    function transferFrom(address from, address to, uint256 value)public returns(\n', '        bool\n', '    );\n', '    function approve(address spender, uint256 value)public returns(bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '   * @dev Burns a all amount of tokens of address.\n', '   */\n', '    function burn()public {\n', '        uint256 _value = balances[msg.sender];\n', "        // no need to require value <= totalSupply, since that would imply the sender's\n", '        // balance is greater than the totalSupply, which *should* be an assertion\n', '        // failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0), _value);\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20,BurnableToken {\n', '    mapping(address => mapping(address => uint256))internal allowed;\n', '\n', '    /**\n', '  * @dev Transfer tokens from one address to another\n', '  * @param _from address The address which you want to send tokens from\n', '  * @param _to address The address which you want to transfer to\n', '  * @param _value uint256 the amount of tokens to be transferred\n', '  */\n', '    function transferFrom(address _from, address _to, uint256 _value)public whenNotPaused checkAdditionalTokenLock(_value) returns(\n', '        bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    /**\n', '  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '  *\n', '  * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '  * @param _spender The address which will spend the funds.\n', '  * @param _value The amount of tokens to be spent.\n', '  */\n', '    function approve(address _spender, uint256 _value)public checkAdditionalTokenLock(_value) returns(\n', '        bool\n', '    ) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    /**\n', '  * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '  * @param _owner address The address which owns the funds.\n', '  * @param _spender address The address which will spend the funds.\n', '  * @return A uint256 specifying the amount of tokens still available for the spender.\n', '  */\n', '    function allowance(address _owner, address _spender)public constant returns(\n', '        uint256 remaining\n', '    ) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    /**\n', '  * approve should be called when allowed[_spender] == 0. To increment\n', '  * allowed value is better to use this function to avoid 2 calls (and wait until\n', '  * the first transaction is mined)\n', '  * From MonolithDAO Token.sol\n', '  */\n', '    function increaseApproval(address _spender, uint _addedValue)public checkAdditionalTokenLock(_addedValue) returns(\n', '        bool success\n', '    ) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    function decreaseApproval(address _spender, uint _subtractedValue)public returns(\n', '        bool success\n', '    ) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', 'contract SMRTCoin is StandardToken {\n', '    string public constant name = "SMRT";\n', '    uint public constant decimals = 18;\n', '    string public constant symbol = "SMRT";\n', '    using SafeMath for uint256; uint256 public weiRaised = 0; address depositWalletAddress; \n', '    event Buy(address _from, uint256 _ethInWei, string userId); \n', '    \n', '    function SMRTCoin()public {\n', '        owner = msg.sender;\n', '        totalSupply = 600000000 * (10 ** decimals);\n', '        preICOReserveTokens = 90000000 * (10 ** decimals);\n', '        icoReserveTokens = 210000000 * (10 ** decimals);\n', '        depositWalletAddress = 0x85a98805C17701504C252eAAB99f60C7c204A785; //TODO change\n', '        businessReserveAddress = 0x73FEC20272a555Af1AEA4bF27D406683632c2a8c; \n', '        balances[owner] = totalSupply;\n', '        emit Transfer(address(0), owner, totalSupply);\n', '        startPreSale = now; //TODO update 1521900000 24 march 14 00 00 UTC\n', '        endPreSale = 1524319200; //21 April 14 00 00 utc\n', '        startSale = endPreSale + 1;\n', '        endSale = startSale + 30 days;\n', '    }\n', '    function ()public {\n', '        revert();\n', '    }\n', '    /**\n', '   * This will be called by adding data to represnet data.\n', '   */\n', '    function buy(string userId)public payable whenNotPaused {\n', '        require(msg.value > 0);\n', '        require(msg.sender != address(0));\n', '        weiRaised += msg.value;\n', '        forwardFunds();\n', '        emit Buy(msg.sender, msg.value, userId);\n', '    }\n', '    /**\n', '   * This function will called by only distributors to send tokens by calculating from offchain listners\n', '   */\n', '    function getBonustokens(uint256 tokens)internal returns(uint256 bonusTokens) {\n', '        require(now <= endSale);\n', '        uint256 bonus;\n', '        if (now <= endPreSale) {\n', '            bonus = 50;\n', '        } else if (now < startSale + 1 weeks) {\n', '            bonus = 10;\n', '        } else if (now < startSale + 2 weeks) {\n', '            bonus = 5;\n', '        }\n', '\n', '        bonusTokens = ((tokens / 100) * bonus);\n', '    }\n', '    function CrowdSale(address recieverAddress, uint256 tokens)public onlyOwner {\n', '        tokens =  tokens.add(getBonustokens(tokens));\n', '        uint256 tokenLimit = (tokens.mul(20)).div(100); //as 20 becuase its 10 percnet of total\n', '        incentiveTokensLimit  = incentiveTokensLimit.add(tokenLimit);\n', '        if (now <= endPreSale && preICOReserveTokens >= tokens) {\n', '            preICOReserveTokens = preICOReserveTokens.sub(tokens);\n', '            transfer(businessReserveAddress, tokens);\n', '            transfer(recieverAddress, tokens);\n', '        } else if (now < endSale && icoReserveTokens >= tokens) {\n', '            icoReserveTokens = icoReserveTokens.sub(tokens);\n', '            transfer(businessReserveAddress, tokens);\n', '            transfer(recieverAddress, tokens);\n', '        }\n', '        else{ \n', '            revert();\n', '        }\n', '    }\n', '    /**\n', '  * @dev Determines how ETH is stored/forwarded on purchases.\n', '  */\n', '    function forwardFunds()internal {\n', '        depositWalletAddress.transfer(msg.value);\n', '    }\n', '    function changeDepositWalletAddress(address newDepositWalletAddr)external onlyOwner {\n', '        require(newDepositWalletAddr != 0);\n', '        depositWalletAddress = newDepositWalletAddr;\n', '    }\n', '    function updateSaleTime(uint256 _startSale, uint256 _endSale)external onlyOwner {\n', '        startSale = _startSale;\n', '        endSale = _endSale;\n', '    }\n', '\n', ' \n', '\n', '}']
