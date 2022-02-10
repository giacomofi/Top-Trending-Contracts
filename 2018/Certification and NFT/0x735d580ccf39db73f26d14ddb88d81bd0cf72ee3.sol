['pragma solidity ^0.4.11;\n', '\n', '// Token Issue Smart Contract for Bitconch Coin\n', '// Symbol       : BUS\n', '// Name         : Bitconch Coin\n', '// Total Supply : 50 Billion\n', '// Decimal      : 18\n', '// Compiler     : 0.4.11+commit.68ef5810.Emscripten.clang\n', '// Optimazation : Yes\n', '\n', '\n', '// @title SafeMath\n', '// @dev Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control functions\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    // @dev Constructor sets the original `owner` of the contract to the sender account.\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // @dev Throws if called by any account other than the owner.\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    // @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    // @param newOwner The address to transfer ownership to.\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev the ownership of contract needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '    address public pendingOwner;\n', '\n', '    // @dev Modifier throws if called by any account other than the pendingOwner.\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner);\n', '        _;\n', '    }\n', '\n', '    // @dev Allows the current owner to set the pendingOwner address.\n', '    // @param newOwner The address to transfer ownership to.\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        pendingOwner = newOwner;\n', '    }\n', '\n', '    // @dev Allows the pendingOwner address to finalize the transfer.\n', '    function claimOwnership() onlyPendingOwner {\n', '        owner = pendingOwner;\n', '        pendingOwner = 0x0;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Contactable token\n', ' * @dev Allowing the owner to provide a string with their contact information.\n', ' */\n', 'contract Contactable is Ownable{\n', '\n', '    string public contactInformation;\n', '\n', '    // @dev Allows the owner to set a string with their contact information.\n', '    // @param info The contact information to attach to the contract.\n', '    function setContactInformation(string info) onlyOwner{\n', '        contactInformation = info;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Contracts that should not own Ether\n', ' * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up\n', ' * in the contract, it will allow the owner to reclaim this ether.\n', ' * @notice Ether can still be send to this contract by:\n', ' * calling functions labeled `payable`\n', ' * `selfdestruct(contract_address)`\n', ' * mining directly to the contract address\n', '*/\n', 'contract HasNoEther is Ownable {\n', '\n', '    /**\n', '    * @dev Constructor that rejects incoming Ether\n', '    * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '    * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '    * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '    * we could use assembly to access msg.value.\n', '    */\n', '    function HasNoEther() payable {\n', '        require(msg.value == 0);\n', '    }\n', '\n', '    /**\n', '     * @dev Disallows direct send by settings a default function without the `payable` flag.\n', '     */\n', '    function() external {\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer all Ether held by the contract to the owner.\n', '     */\n', '    function reclaimEther() external onlyOwner {\n', '        assert(owner.send(this.balance));\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implementation of the ERC20Interface\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    // private\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 _totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    // @dev Get the total token supply\n', '    function totalSupply() constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // @dev Gets the balance of the specified address.\n', '    // @param _owner The address to query the the balance of.\n', '    // @return An uint256 representing the amount owned by the passed address.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // @dev transfer token for a specified address\n', '    // @param _to The address to transfer to.\n', '    // @param _value The amount to be transferred.\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        require(_to != 0x0 );\n', '        require(_value > 0 );\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @dev Transfer tokens from one address to another\n', '    // @param _from address The address which you want to send tokens from\n', '    // @param _to address The address which you want to transfer to\n', '    // @param _value uint256 the amout of tokens to be transfered\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        require(_from != 0x0 );\n', '        require(_to != 0x0 );\n', '        require(_value > 0 );\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    // @param _spender The address which will spend the funds.\n', '    // @param _value The amount of tokens to be spent.\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        require(_spender != 0x0 );\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        // allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        // already 0 to mitigate the race condition described here:\n', '        // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    // @param _owner address The address which owns the funds.\n', '    // @param _spender address The address which will spend the funds.\n', '    // @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '\n', '    function isToken() public constant returns (bool) {\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev FreezableToken\n', ' *\n', ' */\n', 'contract FreezableToken is StandardToken, Ownable {\n', '    mapping (address => bool) public frozenAccounts;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    // @dev freeze account or unfreezen.\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccounts[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    // @dev Limit token transfer if _sender is frozen.\n', '    modifier canTransfer(address _sender) {\n', '        require(!frozenAccounts[_sender]);\n', '\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) canTransfer(msg.sender) returns (bool success) {\n', '        // Call StandardToken.transfer()\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) returns (bool success) {\n', '        // Call StandardToken.transferForm()\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BusToken\n', ' * @dev The BusToken contract is Claimable, and provides ERC20 standard token.\n', ' */\n', 'contract BusToken is Claimable, Contactable, HasNoEther, FreezableToken {\n', '    // @dev Constructor initial token info\n', '    function BusToken(){\n', '        uint256 _decimals = 18;\n', '        uint256 _supply = 50000000000*(10**_decimals);\n', '\n', '        _totalSupply = _supply;\n', '        balances[msg.sender] = _supply;\n', '        name = "Bitconch Coin";\n', '        symbol = "BUS";\n', '        decimals = _decimals;\n', '        contactInformation = "Bitconch Contact Email:info@bitconch.io";\n', '    }\n', '}\n', '\n', '\n', 'contract BusTokenLock is Ownable, HasNoEther {\n', '    using SafeMath for uint256;\n', '\n', '    // @dev How many investors we have now\n', '    uint256 public investorCount;\n', '    // @dev How many tokens investors have claimed so far\n', '    uint256 public totalClaimed;\n', '    // @dev How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded\n', '    uint256 public tokensAllocatedTotal;\n', '\n', '    // must hold as much as tokens\n', '    uint256 public tokensAtLeastHold;\n', '\n', '    struct balance{\n', '        address investor;\n', '        uint256 amount;\n', '        uint256 freezeEndAt;\n', '        bool claimed;\n', '    }\n', '\n', '    mapping(address => balance[]) public balances;\n', '    // @dev How many tokens investors have claimed\n', '    mapping(address => uint256) public claimed;\n', '\n', '    // @dev token\n', '    FreezableToken public token;\n', '\n', '    // @dev We allocated tokens for investor\n', '    event Invested(address investor, uint256 amount, uint256 hour);\n', '\n', '    // @dev We distributed tokens to an investor\n', '    event Distributed(address investors, uint256 count);\n', '\n', '    /**\n', '     * @dev Create contract where lock up period is given days\n', '     *\n', '     * @param _owner Who can load investor data and lock\n', '     * @param _token Token contract address we are distributing\n', '     *\n', '     */\n', '    function BusTokenLock(address _owner, address _token) {\n', '        require(_owner != 0x0);\n', '        require(_token != 0x0);\n', '\n', '        owner = _owner;\n', '        token = FreezableToken(_token);\n', '    }\n', '\n', '    // @dev Add investor\n', '    function addInvestor(address investor, uint256 _amount, uint256 hour) public onlyOwner {\n', '        require(investor != 0x0);\n', '        require(_amount > 0); // No empty buys\n', '\n', '        uint256 amount = _amount *(10**token.decimals());\n', '        if(balances[investor].length == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        balances[investor].push(balance(investor, amount, now + hour*60*60, false));\n', '        tokensAllocatedTotal += amount;\n', '        tokensAtLeastHold += amount;\n', '        // Do not lock if the given tokens are not on this contract\n', '        require(token.balanceOf(address(this)) >= tokensAtLeastHold);\n', '\n', '        Invested(investor, amount, hour);\n', '    }\n', '\n', '    // @dev can only withdraw rest of investor&#39;s tokens\n', '    function withdrawLeftTokens() onlyOwner {\n', '        token.transfer(owner, token.balanceOf(address(this))-tokensAtLeastHold);\n', '    }\n', '\n', '    // @dev Get the current balance of tokens\n', '    // @return uint256 How many tokens there are currently\n', '    function getBalance() public constant returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    // @dev Claim N bought tokens to the investor as the msg sender\n', '    function claim() {\n', '        withdraw(msg.sender);\n', '    }\n', '\n', '    function withdraw(address investor) internal {\n', '        require(balances[investor].length > 0);\n', '\n', '        uint256 nowTS = now;\n', '        uint256 withdrawTotal;\n', '        for (uint i = 0; i < balances[investor].length; i++){\n', '            if(balances[investor][i].claimed){\n', '                continue;\n', '            }\n', '            if(nowTS<balances[investor][i].freezeEndAt){\n', '                continue;\n', '            }\n', '\n', '            balances[investor][i].claimed=true;\n', '            withdrawTotal += balances[investor][i].amount;\n', '        }\n', '\n', '        claimed[investor] += withdrawTotal;\n', '        totalClaimed += withdrawTotal;\n', '        token.transfer(investor, withdrawTotal);\n', '        tokensAtLeastHold -= withdrawTotal;\n', '        require(token.balanceOf(address(this)) >= tokensAtLeastHold);\n', '\n', '        Distributed(investor, withdrawTotal);\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '// Token Issue Smart Contract for Bitconch Coin\n', '// Symbol       : BUS\n', '// Name         : Bitconch Coin\n', '// Total Supply : 50 Billion\n', '// Decimal      : 18\n', '// Compiler     : 0.4.11+commit.68ef5810.Emscripten.clang\n', '// Optimazation : Yes\n', '\n', '\n', '// @title SafeMath\n', '// @dev Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control functions\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    // @dev Constructor sets the original `owner` of the contract to the sender account.\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // @dev Throws if called by any account other than the owner.\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    // @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    // @param newOwner The address to transfer ownership to.\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev the ownership of contract needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '    address public pendingOwner;\n', '\n', '    // @dev Modifier throws if called by any account other than the pendingOwner.\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner);\n', '        _;\n', '    }\n', '\n', '    // @dev Allows the current owner to set the pendingOwner address.\n', '    // @param newOwner The address to transfer ownership to.\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        pendingOwner = newOwner;\n', '    }\n', '\n', '    // @dev Allows the pendingOwner address to finalize the transfer.\n', '    function claimOwnership() onlyPendingOwner {\n', '        owner = pendingOwner;\n', '        pendingOwner = 0x0;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Contactable token\n', ' * @dev Allowing the owner to provide a string with their contact information.\n', ' */\n', 'contract Contactable is Ownable{\n', '\n', '    string public contactInformation;\n', '\n', '    // @dev Allows the owner to set a string with their contact information.\n', '    // @param info The contact information to attach to the contract.\n', '    function setContactInformation(string info) onlyOwner{\n', '        contactInformation = info;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Contracts that should not own Ether\n', ' * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up\n', ' * in the contract, it will allow the owner to reclaim this ether.\n', ' * @notice Ether can still be send to this contract by:\n', ' * calling functions labeled `payable`\n', ' * `selfdestruct(contract_address)`\n', ' * mining directly to the contract address\n', '*/\n', 'contract HasNoEther is Ownable {\n', '\n', '    /**\n', '    * @dev Constructor that rejects incoming Ether\n', '    * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '    * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '    * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '    * we could use assembly to access msg.value.\n', '    */\n', '    function HasNoEther() payable {\n', '        require(msg.value == 0);\n', '    }\n', '\n', '    /**\n', '     * @dev Disallows direct send by settings a default function without the `payable` flag.\n', '     */\n', '    function() external {\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer all Ether held by the contract to the owner.\n', '     */\n', '    function reclaimEther() external onlyOwner {\n', '        assert(owner.send(this.balance));\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implementation of the ERC20Interface\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    // private\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 _totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    // @dev Get the total token supply\n', '    function totalSupply() constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // @dev Gets the balance of the specified address.\n', '    // @param _owner The address to query the the balance of.\n', '    // @return An uint256 representing the amount owned by the passed address.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // @dev transfer token for a specified address\n', '    // @param _to The address to transfer to.\n', '    // @param _value The amount to be transferred.\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        require(_to != 0x0 );\n', '        require(_value > 0 );\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @dev Transfer tokens from one address to another\n', '    // @param _from address The address which you want to send tokens from\n', '    // @param _to address The address which you want to transfer to\n', '    // @param _value uint256 the amout of tokens to be transfered\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        require(_from != 0x0 );\n', '        require(_to != 0x0 );\n', '        require(_value > 0 );\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    // @param _spender The address which will spend the funds.\n', '    // @param _value The amount of tokens to be spent.\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        require(_spender != 0x0 );\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        // allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        // already 0 to mitigate the race condition described here:\n', '        // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    // @param _owner address The address which owns the funds.\n', '    // @param _spender address The address which will spend the funds.\n', '    // @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '\n', '    function isToken() public constant returns (bool) {\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev FreezableToken\n', ' *\n', ' */\n', 'contract FreezableToken is StandardToken, Ownable {\n', '    mapping (address => bool) public frozenAccounts;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    // @dev freeze account or unfreezen.\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccounts[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    // @dev Limit token transfer if _sender is frozen.\n', '    modifier canTransfer(address _sender) {\n', '        require(!frozenAccounts[_sender]);\n', '\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) canTransfer(msg.sender) returns (bool success) {\n', '        // Call StandardToken.transfer()\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) returns (bool success) {\n', '        // Call StandardToken.transferForm()\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BusToken\n', ' * @dev The BusToken contract is Claimable, and provides ERC20 standard token.\n', ' */\n', 'contract BusToken is Claimable, Contactable, HasNoEther, FreezableToken {\n', '    // @dev Constructor initial token info\n', '    function BusToken(){\n', '        uint256 _decimals = 18;\n', '        uint256 _supply = 50000000000*(10**_decimals);\n', '\n', '        _totalSupply = _supply;\n', '        balances[msg.sender] = _supply;\n', '        name = "Bitconch Coin";\n', '        symbol = "BUS";\n', '        decimals = _decimals;\n', '        contactInformation = "Bitconch Contact Email:info@bitconch.io";\n', '    }\n', '}\n', '\n', '\n', 'contract BusTokenLock is Ownable, HasNoEther {\n', '    using SafeMath for uint256;\n', '\n', '    // @dev How many investors we have now\n', '    uint256 public investorCount;\n', '    // @dev How many tokens investors have claimed so far\n', '    uint256 public totalClaimed;\n', '    // @dev How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded\n', '    uint256 public tokensAllocatedTotal;\n', '\n', '    // must hold as much as tokens\n', '    uint256 public tokensAtLeastHold;\n', '\n', '    struct balance{\n', '        address investor;\n', '        uint256 amount;\n', '        uint256 freezeEndAt;\n', '        bool claimed;\n', '    }\n', '\n', '    mapping(address => balance[]) public balances;\n', '    // @dev How many tokens investors have claimed\n', '    mapping(address => uint256) public claimed;\n', '\n', '    // @dev token\n', '    FreezableToken public token;\n', '\n', '    // @dev We allocated tokens for investor\n', '    event Invested(address investor, uint256 amount, uint256 hour);\n', '\n', '    // @dev We distributed tokens to an investor\n', '    event Distributed(address investors, uint256 count);\n', '\n', '    /**\n', '     * @dev Create contract where lock up period is given days\n', '     *\n', '     * @param _owner Who can load investor data and lock\n', '     * @param _token Token contract address we are distributing\n', '     *\n', '     */\n', '    function BusTokenLock(address _owner, address _token) {\n', '        require(_owner != 0x0);\n', '        require(_token != 0x0);\n', '\n', '        owner = _owner;\n', '        token = FreezableToken(_token);\n', '    }\n', '\n', '    // @dev Add investor\n', '    function addInvestor(address investor, uint256 _amount, uint256 hour) public onlyOwner {\n', '        require(investor != 0x0);\n', '        require(_amount > 0); // No empty buys\n', '\n', '        uint256 amount = _amount *(10**token.decimals());\n', '        if(balances[investor].length == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        balances[investor].push(balance(investor, amount, now + hour*60*60, false));\n', '        tokensAllocatedTotal += amount;\n', '        tokensAtLeastHold += amount;\n', '        // Do not lock if the given tokens are not on this contract\n', '        require(token.balanceOf(address(this)) >= tokensAtLeastHold);\n', '\n', '        Invested(investor, amount, hour);\n', '    }\n', '\n', "    // @dev can only withdraw rest of investor's tokens\n", '    function withdrawLeftTokens() onlyOwner {\n', '        token.transfer(owner, token.balanceOf(address(this))-tokensAtLeastHold);\n', '    }\n', '\n', '    // @dev Get the current balance of tokens\n', '    // @return uint256 How many tokens there are currently\n', '    function getBalance() public constant returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    // @dev Claim N bought tokens to the investor as the msg sender\n', '    function claim() {\n', '        withdraw(msg.sender);\n', '    }\n', '\n', '    function withdraw(address investor) internal {\n', '        require(balances[investor].length > 0);\n', '\n', '        uint256 nowTS = now;\n', '        uint256 withdrawTotal;\n', '        for (uint i = 0; i < balances[investor].length; i++){\n', '            if(balances[investor][i].claimed){\n', '                continue;\n', '            }\n', '            if(nowTS<balances[investor][i].freezeEndAt){\n', '                continue;\n', '            }\n', '\n', '            balances[investor][i].claimed=true;\n', '            withdrawTotal += balances[investor][i].amount;\n', '        }\n', '\n', '        claimed[investor] += withdrawTotal;\n', '        totalClaimed += withdrawTotal;\n', '        token.transfer(investor, withdrawTotal);\n', '        tokensAtLeastHold -= withdrawTotal;\n', '        require(token.balanceOf(address(this)) >= tokensAtLeastHold);\n', '\n', '        Distributed(investor, withdrawTotal);\n', '    }\n', '}']