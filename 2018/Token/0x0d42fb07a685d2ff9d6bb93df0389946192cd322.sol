['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) constant returns (uint256);\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '    function approve(address spender, uint256 value) returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // require (_value <= _allowance);\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifing the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.db.getCollection(&#39;transactions&#39;).find({})\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable, Pausable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '    uint256 public constant maxTokensToMint = 7320000000 ether;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will recieve the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) whenNotPaused onlyOwner returns (bool) {\n', '        return mintInternal(_to, _amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() whenNotPaused onlyOwner returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {\n', '        require(totalSupply.add(_amount) <= maxTokensToMint);\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(this, _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Avatar is MintableToken {\n', '\n', '    string public constant name = "AvataraCoin";\n', '\n', '    string public constant symbol = "VTR";\n', '\n', '    bool public transferEnabled = false;\n', '\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public rate = 100000;\n', '\n', '    uint256 public constant hardCap = 30000 ether;\n', '\n', '    uint256 public weiFounded = 0;\n', '\n', '    address public approvedUser = 0x48BAa849622fb4481c0C4D9E7a68bcE6b63b0213;\n', '\n', '    address public wallet = 0x48BAa849622fb4481c0C4D9E7a68bcE6b63b0213;\n', '\n', '    uint64 public dateStart = 1520348400;\n', '\n', '    bool public icoFinished = false;\n', '\n', '    uint256 public constant maxTokenToBuy = 4392000000 ether;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {\n', '        require(_to != address(this) && _to != address(0));\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amout of tokens to be transfered\n', '    */\n', '    function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {\n', '        require(_to != address(this) && _to != address(0));\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the transfer is enabled.\n', '     */\n', '    modifier canTransfer() {\n', '        require(transferEnabled);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwnerOrApproved() {\n', '        require(msg.sender == owner || msg.sender == approvedUser);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop transfering tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function enableTransfer() onlyOwner returns (bool) {\n', '        transferEnabled = true;\n', '        return true;\n', '    }\n', '\n', '    function finishIco() onlyOwner returns (bool) {\n', '        icoFinished = true;\n', '        return true;\n', '    }\n', '\n', '    modifier canBuyTokens() {\n', '        require(!icoFinished && weiFounded <= hardCap);\n', '        _;\n', '    }\n', '\n', '    function setApprovedUser(address _user) onlyOwner returns (bool) {\n', '        require(_user != address(0));\n', '        approvedUser = _user;\n', '        return true;\n', '    }\n', '\n', '\n', '    function changeRate(uint256 _rate) onlyOwnerOrApproved returns (bool) {\n', '        require(_rate > 0);\n', '        rate = _rate;\n', '        return true;\n', '    }\n', '\n', '    function () payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) canBuyTokens whenNotPaused payable {\n', '        require(beneficiary != 0x0);\n', '        require(msg.value >= 100 finney);\n', '\n', '        uint256 weiAmount = msg.value;\n', '        uint256 bonus = 0;\n', '        uint256 totalWei = weiAmount.add(weiFounded);\n', '        if(totalWei <= 600 ether){\n', '            require(weiAmount >= 1500 finney);\n', '            bonus = 51;\n', '        }else if (totalWei <= 3000 ether){\n', '            require(weiAmount >= 1500 finney);\n', '            bonus = 30;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 51;\n', '            }\n', '        }else if (totalWei <= 12000 ether){\n', '            require(weiAmount >= 1000 finney);\n', '            bonus = 21;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 42;\n', '            }\n', '        }else if (totalWei <= 21000 ether){\n', '            require(weiAmount >= 510 finney);\n', '            bonus = 18;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 39;\n', '            }\n', '        }else if (totalWei <= 30000 ether){\n', '            require(weiAmount >= 300 finney);\n', '            bonus = 12;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 33;\n', '            }\n', '        }\n', '        // calculate token amount to be created\n', '\n', '        uint256 tokens = weiAmount.mul(rate);\n', '\n', '\n', '\n', '        if(bonus > 0){\n', '            tokens += tokens.mul(bonus).div(100);\n', '        }\n', '\n', '        require(totalSupply.add(tokens) <= maxTokenToBuy);\n', '\n', '        mintInternal(beneficiary, tokens);\n', '        weiFounded = totalWei;\n', '        TokenPurchase(msg.sender, beneficiary, tokens);\n', '        forwardFunds();\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '\n', '    function changeWallet(address _newWallet) onlyOwner returns (bool) {\n', '        require(_newWallet != 0x0);\n', '        wallet = _newWallet;\n', '        return true;\n', '    }\n', '\n', '    \n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) constant returns (uint256);\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '    function approve(address spender, uint256 value) returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // require (_value <= _allowance);\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifing the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', "     * @dev Modifier to make a function callable only when the contract is paused.db.getCollection('transactions').find({})\n", '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable, Pausable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '    uint256 public constant maxTokensToMint = 7320000000 ether;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will recieve the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) whenNotPaused onlyOwner returns (bool) {\n', '        return mintInternal(_to, _amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() whenNotPaused onlyOwner returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {\n', '        require(totalSupply.add(_amount) <= maxTokensToMint);\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(this, _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Avatar is MintableToken {\n', '\n', '    string public constant name = "AvataraCoin";\n', '\n', '    string public constant symbol = "VTR";\n', '\n', '    bool public transferEnabled = false;\n', '\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public rate = 100000;\n', '\n', '    uint256 public constant hardCap = 30000 ether;\n', '\n', '    uint256 public weiFounded = 0;\n', '\n', '    address public approvedUser = 0x48BAa849622fb4481c0C4D9E7a68bcE6b63b0213;\n', '\n', '    address public wallet = 0x48BAa849622fb4481c0C4D9E7a68bcE6b63b0213;\n', '\n', '    uint64 public dateStart = 1520348400;\n', '\n', '    bool public icoFinished = false;\n', '\n', '    uint256 public constant maxTokenToBuy = 4392000000 ether;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {\n', '        require(_to != address(this) && _to != address(0));\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amout of tokens to be transfered\n', '    */\n', '    function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {\n', '        require(_to != address(this) && _to != address(0));\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the transfer is enabled.\n', '     */\n', '    modifier canTransfer() {\n', '        require(transferEnabled);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwnerOrApproved() {\n', '        require(msg.sender == owner || msg.sender == approvedUser);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop transfering tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function enableTransfer() onlyOwner returns (bool) {\n', '        transferEnabled = true;\n', '        return true;\n', '    }\n', '\n', '    function finishIco() onlyOwner returns (bool) {\n', '        icoFinished = true;\n', '        return true;\n', '    }\n', '\n', '    modifier canBuyTokens() {\n', '        require(!icoFinished && weiFounded <= hardCap);\n', '        _;\n', '    }\n', '\n', '    function setApprovedUser(address _user) onlyOwner returns (bool) {\n', '        require(_user != address(0));\n', '        approvedUser = _user;\n', '        return true;\n', '    }\n', '\n', '\n', '    function changeRate(uint256 _rate) onlyOwnerOrApproved returns (bool) {\n', '        require(_rate > 0);\n', '        rate = _rate;\n', '        return true;\n', '    }\n', '\n', '    function () payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) canBuyTokens whenNotPaused payable {\n', '        require(beneficiary != 0x0);\n', '        require(msg.value >= 100 finney);\n', '\n', '        uint256 weiAmount = msg.value;\n', '        uint256 bonus = 0;\n', '        uint256 totalWei = weiAmount.add(weiFounded);\n', '        if(totalWei <= 600 ether){\n', '            require(weiAmount >= 1500 finney);\n', '            bonus = 51;\n', '        }else if (totalWei <= 3000 ether){\n', '            require(weiAmount >= 1500 finney);\n', '            bonus = 30;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 51;\n', '            }\n', '        }else if (totalWei <= 12000 ether){\n', '            require(weiAmount >= 1000 finney);\n', '            bonus = 21;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 42;\n', '            }\n', '        }else if (totalWei <= 21000 ether){\n', '            require(weiAmount >= 510 finney);\n', '            bonus = 18;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 39;\n', '            }\n', '        }else if (totalWei <= 30000 ether){\n', '            require(weiAmount >= 300 finney);\n', '            bonus = 12;\n', '            if(weiAmount >= 33 ether){\n', '                bonus = 33;\n', '            }\n', '        }\n', '        // calculate token amount to be created\n', '\n', '        uint256 tokens = weiAmount.mul(rate);\n', '\n', '\n', '\n', '        if(bonus > 0){\n', '            tokens += tokens.mul(bonus).div(100);\n', '        }\n', '\n', '        require(totalSupply.add(tokens) <= maxTokenToBuy);\n', '\n', '        mintInternal(beneficiary, tokens);\n', '        weiFounded = totalWei;\n', '        TokenPurchase(msg.sender, beneficiary, tokens);\n', '        forwardFunds();\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '\n', '    function changeWallet(address _newWallet) onlyOwner returns (bool) {\n', '        require(_newWallet != 0x0);\n', '        wallet = _newWallet;\n', '        return true;\n', '    }\n', '\n', '    \n', '}']