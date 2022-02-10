['pragma solidity ^0.4.20;\n', '// ----------------------------------------------------------------------------------------------\n', '// SPIKE Token by SPIKING Limited.\n', '// An ERC223 standard\n', '//\n', '// author: SPIKE Team\n', '// Contact: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="31525d545c545f714241585a585f561f585e">[email&#160;protected]</a>\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    // Get the total token supply\n', '    function totalSupply() public constant returns (uint256 _totalSupply);\n', ' \n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', ' \n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    \n', '    // transfer _value amount of token approved by address _from\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    \n', '    // approve an address with _value amount of tokens\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    // get remaining token approved by _owner to _spender\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '  \n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', ' \n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ERC223 is ERC20{\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success);\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed _data);\n', '}\n', '\n', '/// contract receiver interface\n', 'contract ContractReceiver {  \n', '    function tokenFallback(address _from, uint _value, bytes _data) external;\n', '}\n', '\n', 'contract BasicSPIKE is ERC223 {\n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public constant decimals = 10;\n', '    string public constant symbol = "SPIKE";\n', '    string public constant name = "Spiking";\n', '    uint256 public _totalSupply = 10 ** 20; // total supply is 10^20 unit, equivalent to 10 Billion SPIKE\n', '\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // tradable\n', '    bool public tradable = false;\n', '\n', '    // Balances SPIKE for each account\n', '    mapping(address => uint256) balances;\n', '    \n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '            \n', '    /**\n', '     * Functions with this modifier can only be executed by the owner\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier isTradable(){\n', '        require(tradable == true || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /// @dev Constructor\n', '    function BasicSPIKE() \n', '    public {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '        Transfer(0x0, owner, _totalSupply);\n', '    }\n', '    \n', '    /// @dev Gets totalSupply\n', '    /// @return Total supply\n', '    function totalSupply()\n', '    public \n', '    constant \n', '    returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '        \n', '    /// @dev Gets account&#39;s balance\n', '    /// @param _addr Address of the account\n', '    /// @return Account balance\n', '    function balanceOf(address _addr) \n', '    public\n', '    constant \n', '    returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '    \n', '    \n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) \n', '    private \n', '    view \n', '    returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', ' \n', '    /// @dev Transfers the balance from msg.sender to an account\n', '    /// @param _to Recipient address\n', '    /// @param _value Transfered amount in unit\n', '    /// @return Transfer status\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) \n', '    public \n', '    isTradable\n', '    returns (bool success) {\n', '        require(_to != 0x0);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /// @dev Function that is called when a user or another contract wants to transfer funds .\n', '    /// @param _to Recipient address\n', '    /// @param _value Transfer amount in unit\n', '    /// @param _data the data pass to contract reveiver\n', '    function transfer(\n', '        address _to, \n', '        uint _value, \n', '        bytes _data) \n', '    public\n', '    isTradable \n', '    returns (bool success) {\n', '        require(_to != 0x0);\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        if(isContract(_to)) {\n', '            ContractReceiver receiver = ContractReceiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '            Transfer(msg.sender, _to, _value, _data);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '    \n', '    /// @dev Function that is called when a user or another contract wants to transfer funds .\n', '    /// @param _to Recipient address\n', '    /// @param _value Transfer amount in unit\n', '    /// @param _data the data pass to contract reveiver\n', '    /// @param _custom_fallback custom name of fallback function\n', '    function transfer(\n', '        address _to, \n', '        uint _value, \n', '        bytes _data, \n', '        string _custom_fallback) \n', '    public \n', '    isTradable\n', '    returns (bool success) {\n', '        require(_to != 0x0);\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        if(isContract(_to)) {\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value, _data);\n', '        }\n', '        return true;\n', '    }\n', '         \n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value)\n', '    public\n', '    isTradable\n', '    returns (bool success) {\n', '        require(_to != 0x0);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) \n', '    public\n', '    returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    // get allowance\n', '    function allowance(address _owner, address _spender) \n', '    public\n', '    constant \n', '    returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // withdraw any ERC20 token in this contract to owner\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {\n', '        return ERC223(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    // allow people can transfer their token\n', '    // NOTE: can not turn off\n', '    function turnOnTradable() \n', '    public\n', '    onlyOwner{\n', '        tradable = true;\n', '    }\n', '}\n', '\n', 'contract SPIKE is BasicSPIKE {\n', '\n', '    bool public _selling = true;//initial selling\n', '    \n', '    uint256 public _originalBuyPrice = 50000 * 10**10; // original buy 1ETH = 50000 SPIKE = 50000 * 10**10 unit\n', '\n', '    // List of approved investors\n', '    mapping(address => bool) private approvedInvestorList;\n', '    \n', '    // deposit\n', '    mapping(address => uint256) private deposit;\n', '    \n', '    // icoPercent\n', '    uint256 public _icoPercent = 30;\n', '    \n', '    // _icoSupply is the avalable unit. Initially, it is _totalSupply\n', '    uint256 public _icoSupply = (_totalSupply * _icoPercent) / 100;\n', '    \n', '    // minimum buy 0.3 ETH\n', '    uint256 public _minimumBuy = 3 * 10 ** 17;\n', '    \n', '    // maximum buy 25 ETH\n', '    uint256 public _maximumBuy = 25 * 10 ** 18;\n', '\n', '    // totalTokenSold\n', '    uint256 public totalTokenSold = 0;\n', '\n', '    /**\n', '     * Functions with this modifier check on sale status\n', '     * Only allow sale if _selling is on\n', '     */\n', '    modifier onSale() {\n', '        require(_selling);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Functions with this modifier check the validity of address is investor\n', '     */\n', '    modifier validInvestor() {\n', '        require(approvedInvestorList[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Functions with this modifier check the validity of msg value\n', '     * value must greater than equal minimumBuyPrice\n', '     * total deposit must less than equal maximumBuyPrice\n', '     */\n', '    modifier validValue(){\n', '        // require value >= _minimumBuy AND total deposit of msg.sender <= maximumBuyPrice\n', '        require ( (msg.value >= _minimumBuy) &&\n', '                ( (deposit[msg.sender].add(msg.value)) <= _maximumBuy) );\n', '        _;\n', '    }\n', '\n', '    /// @dev Fallback function allows to buy by ether.\n', '    function()\n', '    public\n', '    payable {\n', '        buySPIKE();\n', '    }\n', '    \n', '    /// @dev buy function allows to buy ether. for using optional data\n', '    function buySPIKE()\n', '    public\n', '    payable\n', '    onSale\n', '    validValue\n', '    validInvestor {\n', '        uint256 requestedUnits = (msg.value * _originalBuyPrice) / 10**18;\n', '        require(balances[owner] >= requestedUnits);\n', '        // prepare transfer data\n', '        balances[owner] = balances[owner].sub(requestedUnits);\n', '        balances[msg.sender] = balances[msg.sender].add(requestedUnits);\n', '        \n', '        // increase total deposit amount\n', '        deposit[msg.sender] = deposit[msg.sender].add(msg.value);\n', '        \n', '        // check total and auto turnOffSale\n', '        totalTokenSold = totalTokenSold.add(requestedUnits);\n', '        if (totalTokenSold >= _icoSupply){\n', '            _selling = false;\n', '        }\n', '        \n', '        // submit transfer\n', '        Transfer(owner, msg.sender, requestedUnits);\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    /// @dev Constructor\n', '    function SPIKE() BasicSPIKE()\n', '    public {\n', '        setBuyPrice(_originalBuyPrice);\n', '    }\n', '    \n', '    /// @dev Enables sale \n', '    function turnOnSale() onlyOwner \n', '    public {\n', '        _selling = true;\n', '    }\n', '\n', '    /// @dev Disables sale\n', '    function turnOffSale() onlyOwner \n', '    public {\n', '        _selling = false;\n', '    }\n', '    \n', '    /// @dev set new icoPercent\n', '    /// @param newIcoPercent new value of icoPercent\n', '    function setIcoPercent(uint256 newIcoPercent)\n', '    public \n', '    onlyOwner {\n', '        _icoPercent = newIcoPercent;\n', '        _icoSupply = (_totalSupply * _icoPercent) / 100;\n', '    }\n', '    \n', '    /// @dev set new _maximumBuy\n', '    /// @param newMaximumBuy new value of _maximumBuy\n', '    function setMaximumBuy(uint256 newMaximumBuy)\n', '    public \n', '    onlyOwner {\n', '        _maximumBuy = newMaximumBuy;\n', '    }\n', '\n', '    /// @dev Updates buy price (owner ONLY)\n', '    /// @param newBuyPrice New buy price (in UNIT) 1ETH <=> 100 000 0000000000 unit\n', '    function setBuyPrice(uint256 newBuyPrice) \n', '    onlyOwner \n', '    public {\n', '        require(newBuyPrice>0);\n', '        _originalBuyPrice = newBuyPrice; // unit\n', '        // control _maximumBuy_USD = 10,000 USD, SPIKE price is 0.01USD\n', '        // maximumBuy_SPIKE = 1000,000 SPIKE = 1000,000,0000000000 unit = 10^16\n', '        _maximumBuy = (10**18 * 10**16) /_originalBuyPrice;\n', '    }\n', '    \n', '    /// @dev check address is approved investor\n', '    /// @param _addr address\n', '    function isApprovedInvestor(address _addr)\n', '    public\n', '    constant\n', '    returns (bool) {\n', '        return approvedInvestorList[_addr];\n', '    }\n', '    \n', '    /// @dev get ETH deposit\n', '    /// @param _addr address get deposit\n', '    /// @return amount deposit of an buyer\n', '    function getDeposit(address _addr)\n', '    public\n', '    constant\n', '    returns(uint256){\n', '        return deposit[_addr];\n', '}\n', '    \n', '    /// @dev Adds list of new investors to the investors list and approve all\n', '    /// @param newInvestorList Array of new investors addresses to be added\n', '    function addInvestorList(address[] newInvestorList)\n', '    onlyOwner\n', '    public {\n', '        for (uint256 i = 0; i < newInvestorList.length; i++){\n', '            approvedInvestorList[newInvestorList[i]] = true;\n', '        }\n', '    }\n', '\n', '    /// @dev Removes list of investors from list\n', '    /// @param investorList Array of addresses of investors to be removed\n', '    function removeInvestorList(address[] investorList)\n', '    onlyOwner\n', '    public {\n', '        for (uint256 i = 0; i < investorList.length; i++){\n', '            approvedInvestorList[investorList[i]] = false;\n', '        }\n', '    }\n', '    \n', '    /// @dev Withdraws Ether in contract (Owner only)\n', '    /// @return Status of withdrawal\n', '    function withdraw() onlyOwner \n', '    public \n', '    returns (bool) {\n', '        return owner.send(this.balance);\n', '    }\n', '}']