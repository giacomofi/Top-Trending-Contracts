['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// Gifto Token by Gifto Limited.\n', '// An ERC20 standard\n', '//\n', '// author: Gifto Team\n', '// Contact: datwhnguyen@gmail.com\n', '\n', 'contract ERC20Interface {\n', '    // Get the total token supply\n', '    function totalSupply() public constant returns (uint256 _totalSupply);\n', ' \n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', ' \n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    \n', '    // transfer _value amount of token approved by address _from\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    // approve an address with _value amount of tokens\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    // get remaining token approved by _owner to _spender\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '  \n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', ' \n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', ' \n', 'contract Gifto is ERC20Interface {\n', '    uint256 public constant decimals = 5;\n', '\n', '    string public constant symbol = "GTO";\n', '    string public constant name = "Gifto";\n', '\n', '    bool public _selling = true;//initial selling\n', '    uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 Gifto\n', '    uint256 public _originalBuyPrice = 43 * 10**7; // original buy 1ETH = 4300 Gifto = 43 * 10**7 unit\n', '\n', '    // Owner of this contract\n', '    address public owner;\n', ' \n', '    // Balances Gifto for each account\n', '    mapping(address => uint256) private balances;\n', '    \n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) private allowed;\n', '\n', '    // List of approved investors\n', '    mapping(address => bool) private approvedInvestorList;\n', '    \n', '    // deposit\n', '    mapping(address => uint256) private deposit;\n', '    \n', '    // icoPercent\n', '    uint256 public _icoPercent = 10;\n', '    \n', '    // _icoSupply is the avalable unit. Initially, it is _totalSupply\n', '    uint256 public _icoSupply = _totalSupply * _icoPercent / 100;\n', '    \n', '    // minimum buy 0.3 ETH\n', '    uint256 public _minimumBuy = 3 * 10 ** 17;\n', '    \n', '    // maximum buy 25 ETH\n', '    uint256 public _maximumBuy = 25 * 10 ** 18;\n', '\n', '    // totalTokenSold\n', '    uint256 public totalTokenSold = 0;\n', '    \n', '    // tradable\n', '    bool public tradable = false;\n', '    \n', '    /**\n', '     * Functions with this modifier can only be executed by the owner\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Functions with this modifier check on sale status\n', '     * Only allow sale if _selling is on\n', '     */\n', '    modifier onSale() {\n', '        require(_selling);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Functions with this modifier check the validity of address is investor\n', '     */\n', '    modifier validInvestor() {\n', '        require(approvedInvestorList[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Functions with this modifier check the validity of msg value\n', '     * value must greater than equal minimumBuyPrice\n', '     * total deposit must less than equal maximumBuyPrice\n', '     */\n', '    modifier validValue(){\n', '        // require value >= _minimumBuy AND total deposit of msg.sender <= maximumBuyPrice\n', '        require ( (msg.value >= _minimumBuy) &&\n', '                ( (deposit[msg.sender] + msg.value) <= _maximumBuy) );\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * \n', '     */\n', '    modifier isTradable(){\n', '        require(tradable == true || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /// @dev Fallback function allows to buy ether.\n', '    function()\n', '        public\n', '        payable {\n', '        buyGifto();\n', '    }\n', '    \n', '    /// @dev buy function allows to buy ether. for using optional data\n', '    function buyGifto()\n', '        public\n', '        payable\n', '        onSale\n', '        validValue\n', '        validInvestor {\n', '        uint256 requestedUnits = (msg.value * _originalBuyPrice) / 10**18;\n', '        require(balances[owner] >= requestedUnits);\n', '        // prepare transfer data\n', '        balances[owner] -= requestedUnits;\n', '        balances[msg.sender] += requestedUnits;\n', '        \n', '        // increase total deposit amount\n', '        deposit[msg.sender] += msg.value;\n', '        \n', '        // check total and auto turnOffSale\n', '        totalTokenSold += requestedUnits;\n', '        if (totalTokenSold >= _icoSupply){\n', '            _selling = false;\n', '        }\n', '        \n', '        // submit transfer\n', '        Transfer(owner, msg.sender, requestedUnits);\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    /// @dev Constructor\n', '    function Gifto() \n', '        public {\n', '        owner = msg.sender;\n', '        setBuyPrice(_originalBuyPrice);\n', '        balances[owner] = _totalSupply;\n', '        Transfer(0x0, owner, _totalSupply);\n', '    }\n', '    \n', '    /// @dev Gets totalSupply\n', '    /// @return Total supply\n', '    function totalSupply()\n', '        public \n', '        constant \n', '        returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    /// @dev Enables sale \n', '    function turnOnSale() onlyOwner \n', '        public {\n', '        _selling = true;\n', '    }\n', '\n', '    /// @dev Disables sale\n', '    function turnOffSale() onlyOwner \n', '        public {\n', '        _selling = false;\n', '    }\n', '    \n', '    function turnOnTradable() \n', '        public\n', '        onlyOwner{\n', '        tradable = true;\n', '    }\n', '    \n', '    /// @dev set new icoPercent\n', '    /// @param newIcoPercent new value of icoPercent\n', '    function setIcoPercent(uint256 newIcoPercent)\n', '        public \n', '        onlyOwner {\n', '        _icoPercent = newIcoPercent;\n', '        _icoSupply = _totalSupply * _icoPercent / 100;\n', '    }\n', '    \n', '    /// @dev set new _maximumBuy\n', '    /// @param newMaximumBuy new value of _maximumBuy\n', '    function setMaximumBuy(uint256 newMaximumBuy)\n', '        public \n', '        onlyOwner {\n', '        _maximumBuy = newMaximumBuy;\n', '    }\n', '\n', '    /// @dev Updates buy price (owner ONLY)\n', '    /// @param newBuyPrice New buy price (in unit)\n', '    function setBuyPrice(uint256 newBuyPrice) \n', '        onlyOwner \n', '        public {\n', '        require(newBuyPrice>0);\n', '        _originalBuyPrice = newBuyPrice; // 3000 Gifto = 3000 00000 unit\n', '        // control _maximumBuy_USD = 10,000 USD, Gifto price is 0.1USD\n', '        // maximumBuy_Gifto = 100,000 Gifto = 100,000,00000 unit\n', '        // 3000 Gifto = 1ETH => maximumETH = 100,000,00000 / _originalBuyPrice\n', '        // 100,000,00000/3000 0000 ~ 33ETH => change to wei\n', '        _maximumBuy = 10**18 * 10000000000 /_originalBuyPrice;\n', '    }\n', '        \n', "    /// @dev Gets account's balance\n", '    /// @param _addr Address of the account\n', '    /// @return Account balance\n', '    function balanceOf(address _addr) \n', '        public\n', '        constant \n', '        returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '    \n', '    /// @dev check address is approved investor\n', '    /// @param _addr address\n', '    function isApprovedInvestor(address _addr)\n', '        public\n', '        constant\n', '        returns (bool) {\n', '        return approvedInvestorList[_addr];\n', '    }\n', '    \n', '    /// @dev get ETH deposit\n', '    /// @param _addr address get deposit\n', '    /// @return amount deposit of an buyer\n', '    function getDeposit(address _addr)\n', '        public\n', '        constant\n', '        returns(uint256){\n', '        return deposit[_addr];\n', '}\n', '    \n', '    /// @dev Adds list of new investors to the investors list and approve all\n', '    /// @param newInvestorList Array of new investors addresses to be added\n', '    function addInvestorList(address[] newInvestorList)\n', '        onlyOwner\n', '        public {\n', '        for (uint256 i = 0; i < newInvestorList.length; i++){\n', '            approvedInvestorList[newInvestorList[i]] = true;\n', '        }\n', '    }\n', '\n', '    /// @dev Removes list of investors from list\n', '    /// @param investorList Array of addresses of investors to be removed\n', '    function removeInvestorList(address[] investorList)\n', '        onlyOwner\n', '        public {\n', '        for (uint256 i = 0; i < investorList.length; i++){\n', '            approvedInvestorList[investorList[i]] = false;\n', '        }\n', '    }\n', ' \n', '    /// @dev Transfers the balance from msg.sender to an account\n', '    /// @param _to Recipient address\n', '    /// @param _amount Transfered amount in unit\n', '    /// @return Transfer status\n', '    function transfer(address _to, uint256 _amount)\n', '        public \n', '        isTradable\n', '        returns (bool) {\n', "        // if sender's balance has enough unit and amount >= 0, \n", '        //      and the sum is not overflow,\n', '        // then do transfer \n', '        if ( (balances[msg.sender] >= _amount) &&\n', '             (_amount >= 0) && \n', '             (balances[_to] + _amount > balances[_to]) ) {  \n', '\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '     \n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    )\n', '    public\n', '    isTradable\n', '    returns (bool success) {\n', '        if (balances[_from] >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '    \n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) \n', '        public\n', '        isTradable\n', '        returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    // get allowance\n', '    function allowance(address _owner, address _spender) \n', '        public\n', '        constant \n', '        returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    /// @dev Withdraws Ether in contract (Owner only)\n', '    /// @return Status of withdrawal\n', '    function withdraw() onlyOwner \n', '        public \n', '        returns (bool) {\n', '        return owner.send(this.balance);\n', '    }\n', '}']