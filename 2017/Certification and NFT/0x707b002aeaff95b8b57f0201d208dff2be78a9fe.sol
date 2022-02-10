['pragma solidity ^0.4.11;\n', '\n', 'contract SafeMath {\n', '\n', '    function safeMul(uint256 a, uint256 b) internal constant returns (uint256 ) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal constant returns (uint256 ) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal constant returns (uint256 ) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal constant returns (uint256 ) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', "    /// @dev Transfers sender's tokens to a given address. Returns success.\n", '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            balances[_from] = safeSub(balances[_from], _value);\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '    address public pendingOwner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // Safe transfer of ownership in 2 steps. Once called, a newOwner needs to call claimOwnership() to prove ownership.\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        pendingOwner = newOwner;\n', '    }\n', '\n', '    function claimOwnership() {\n', '        if (msg.sender == pendingOwner) {\n', '            owner = pendingOwner;\n', '            pendingOwner = 0;\n', '        }\n', '    }\n', '}\n', '\n', 'contract MultiOwnable {\n', '\n', '    mapping (address => bool) ownerMap;\n', '    address[] public owners;\n', '\n', '    event OwnerAdded(address indexed _newOwner);\n', '    event OwnerRemoved(address indexed _oldOwner);\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function MultiOwnable() {\n', '        // Add default owner\n', '        address owner = msg.sender;\n', '        ownerMap[owner] = true;\n', '        owners.push(owner);\n', '    }\n', '\n', '    function ownerCount() public constant returns (uint256) {\n', '        return owners.length;\n', '    }\n', '\n', '    function isOwner(address owner) public constant returns (bool) {\n', '        return ownerMap[owner];\n', '    }\n', '\n', '    function addOwner(address owner) onlyOwner public returns (bool) {\n', '        if (!isOwner(owner) && owner != 0) {\n', '            ownerMap[owner] = true;\n', '            owners.push(owner);\n', '\n', '            OwnerAdded(owner);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    function removeOwner(address owner) onlyOwner public returns (bool) {\n', '        if (isOwner(owner)) {\n', '            ownerMap[owner] = false;\n', '            for (uint i = 0; i < owners.length - 1; i++) {\n', '                if (owners[i] == owner) {\n', '                    owners[i] = owners[owners.length - 1];\n', '                    break;\n', '                }\n', '            }\n', '            owners.length -= 1;\n', '\n', '            OwnerRemoved(owner);\n', '            return true;\n', '        } else return false;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '\n', '    bool public paused;\n', '\n', '    modifier ifNotPaused {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier ifPaused {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    // Called by the owner on emergency, triggers paused state\n', '    function pause() external onlyOwner {\n', '        paused = true;\n', '    }\n', '\n', '    // Called by the owner on end of emergency, returns to normal state\n', '    function resume() external onlyOwner ifPaused {\n', '        paused = false;\n', '    }\n', '}\n', '\n', 'contract TokenSpender {\n', '    function receiveApproval(address _from, uint256 _value);\n', '}\n', '\n', 'contract CommonBsToken is StandardToken, MultiOwnable {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals = 18;\n', "    string public version = 'v0.1';\n", '\n', '    address public creator;\n', '    address public seller;     // The main account that holds all tokens at the beginning.\n', '\n', '    uint256 public saleLimit;  // (e18) How many tokens can be sold in total through all tiers or tokensales.\n', '    uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.\n', '    uint256 public totalSales; // Total number of sale (including external sales) made through all tiers or tokensales.\n', '\n', '    bool public locked;\n', '\n', '    event Sell(address indexed _seller, address indexed _buyer, uint256 _value);\n', '    event SellerChanged(address indexed _oldSeller, address indexed _newSeller);\n', '\n', '    event Lock();\n', '    event Unlock();\n', '\n', '    event Burn(address indexed _burner, uint256 _value);\n', '\n', '    modifier onlyUnlocked() {\n', '        if (!isOwner(msg.sender) && locked) throw;\n', '        _;\n', '    }\n', '\n', '    function CommonBsToken(\n', '        address _seller,\n', '        string _name,\n', '        string _symbol,\n', '        uint256 _totalSupplyNoDecimals,\n', '        uint256 _saleLimitNoDecimals\n', '    ) MultiOwnable() {\n', '\n', '        // Lock the transfer function during the presale/crowdsale to prevent speculations.\n', '        locked = true;\n', '\n', '        creator = msg.sender;\n', '        seller = _seller;\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        totalSupply = _totalSupplyNoDecimals * 1e18;\n', '        saleLimit = _saleLimitNoDecimals * 1e18;\n', '\n', '        balances[seller] = totalSupply;\n', '        Transfer(0x0, seller, totalSupply);\n', '    }\n', '\n', '    function changeSeller(address newSeller) onlyOwner public returns (bool) {\n', '        require(newSeller != 0x0 && seller != newSeller);\n', '\n', '        address oldSeller = seller;\n', '        uint256 unsoldTokens = balances[oldSeller];\n', '        balances[oldSeller] = 0;\n', '        balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);\n', '        Transfer(oldSeller, newSeller, unsoldTokens);\n', '\n', '        seller = newSeller;\n', '        SellerChanged(oldSeller, newSeller);\n', '        return true;\n', '    }\n', '\n', '    function sellNoDecimals(address _to, uint256 _value) public returns (bool) {\n', '        return sell(_to, _value * 1e18);\n', '    }\n', '\n', '    function sell(address _to, uint256 _value) onlyOwner public returns (bool) {\n', '\n', '        // Check that we are not out of limit and still can sell tokens:\n', '        if (saleLimit > 0) require(safeSub(saleLimit, safeAdd(tokensSold, _value)) >= 0);\n', '\n', '        require(_to != address(0));\n', '        require(_value > 0);\n', '        require(_value <= balances[seller]);\n', '\n', '        balances[seller] = safeSub(balances[seller], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(seller, _to, _value);\n', '\n', '        tokensSold = safeAdd(tokensSold, _value);\n', '        totalSales = safeAdd(totalSales, 1);\n', '        Sell(seller, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyUnlocked public returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked public returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function lock() onlyOwner public {\n', '        locked = true;\n', '        Lock();\n', '    }\n', '\n', '    function unlock() onlyOwner public {\n', '        locked = false;\n', '        Unlock();\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool) {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value) ;\n', '        totalSupply = safeSub(totalSupply, _value);\n', '        Transfer(msg.sender, 0x0, _value);\n', '        Burn(msg.sender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value) public {\n', '        TokenSpender spender = TokenSpender(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value);\n', '        }\n', '    }\n', '}\n', '\n', 'contract CommonBsPresale is SafeMath, Ownable, Pausable {\n', '\n', '    enum Currency { BTC, LTC, ZEC, DASH, WAVES, USD, EUR }\n', '\n', '    // TODO rename to Buyer?\n', '\n', '    struct Backer {\n', '        uint256 weiReceived; // Amount of wei given by backer\n', '        uint256 tokensSent;  // Amount of tokens received in return to the given amount of ETH.\n', '    }\n', '\n', '    // TODO rename to buyers?\n', '\n', '    // (buyer_eth_address -> struct)\n', '    mapping(address => Backer) public backers;\n', '\n', '    // currency_code => (tx_hash => tokens)\n', '    mapping(uint8 => mapping(bytes32 => uint256)) public externalTxs;\n', '\n', '    CommonBsToken public token; // Token contract reference.\n', '    address public beneficiary; // Address that will receive ETH raised during this crowdsale.\n', '    address public notifier;    // Address that can this crowdsale about changed external conditions.\n', '\n', '    // TODO implement\n', '    uint256 public minWeiToAccept = 0.0001 ether;\n', '\n', '    uint256 public maxCapWei = 0.01 ether;\n', '    uint public tokensPerWei = 400 * 1.25; // Ordinary price: 1 ETH = 400 tokens. Plus 25% bonus during presale.\n', '\n', '    uint public startTime; // Will be setup once in a constructor from now().\n', '    uint public endTime = 1520600400; // 2018-03-09T13:00:00Z\n', '\n', '    // Stats for current crowdsale\n', '\n', '    uint256 public totalInWei         = 0; // Grand total in wei\n', '    uint256 public totalTokensSold    = 0; // Total amount of tokens sold during this crowdsale.\n', '    uint256 public totalEthSales      = 0; // Total amount of ETH contributions during this crowdsale.\n', '    uint256 public totalExternalSales = 0; // Total amount of external contributions (BTC, LTC, USD, etc.) during this crowdsale.\n', '    uint256 public weiReceived        = 0; // Total amount of wei received during this crowdsale smart contract.\n', '\n', '    uint public finalizedTime = 0; // Unix timestamp when finalize() was called.\n', '\n', '    bool public saleEnabled = true;   // if false, then contract will not sell tokens on payment received\n', '\n', '    event BeneficiaryChanged(address indexed _oldAddress, address indexed _newAddress);\n', '    event NotifierChanged(address indexed _oldAddress, address indexed _newAddress);\n', '\n', '    event EthReceived(address indexed _buyer, uint256 _amountWei);\n', '    event ExternalSale(Currency _currency, bytes32 _txIdSha3, address indexed _buyer, uint256 _amountWei, uint256 _tokensE18);\n', '\n', '    modifier respectTimeFrame() {\n', '        require(isSaleOn());\n', '        _;\n', '    }\n', '\n', '    modifier canNotify() {\n', '        require(msg.sender == owner || msg.sender == notifier);\n', '        _;\n', '    }\n', '\n', '    function CommonBsPresale(address _token, address _beneficiary) {\n', '        token = CommonBsToken(_token);\n', '        owner = msg.sender;\n', '        notifier = owner;\n', '        beneficiary = _beneficiary;\n', '        startTime = now;\n', '    }\n', '\n', '    // Override this method to mock current time.\n', '    function getNow() public constant returns (uint) {\n', '        return now;\n', '    }\n', '\n', '    function setSaleEnabled(bool _enabled) public onlyOwner {\n', '        saleEnabled = _enabled;\n', '    }\n', '\n', '    function setBeneficiary(address _beneficiary) public onlyOwner {\n', '        BeneficiaryChanged(beneficiary, _beneficiary);\n', '        beneficiary = _beneficiary;\n', '    }\n', '\n', '    function setNotifier(address _notifier) public onlyOwner {\n', '        NotifierChanged(notifier, _notifier);\n', '        notifier = _notifier;\n', '    }\n', '\n', '    /*\n', '     * The fallback function corresponds to a donation in ETH\n', '     */\n', '    function() public payable {\n', '        if (saleEnabled) sellTokensForEth(msg.sender, msg.value);\n', '    }\n', '\n', '    function sellTokensForEth(address _buyer, uint256 _amountWei) internal ifNotPaused respectTimeFrame {\n', '\n', '        require(_amountWei >= minWeiToAccept);\n', '\n', '        totalInWei = safeAdd(totalInWei, _amountWei);\n', '        weiReceived = safeAdd(weiReceived, _amountWei);\n', '        require(totalInWei <= maxCapWei); // If max cap reached.\n', '\n', '        uint256 tokensE18 = weiToTokens(_amountWei);\n', '        require(token.sell(_buyer, tokensE18)); // Transfer tokens to buyer.\n', '        totalTokensSold = safeAdd(totalTokensSold, tokensE18);\n', '        totalEthSales++;\n', '\n', '        Backer backer = backers[_buyer];\n', '        backer.tokensSent = safeAdd(backer.tokensSent, tokensE18);\n', '        backer.weiReceived = safeAdd(backer.weiReceived, _amountWei);  // Update the total wei collected during the crowdfunding for this backer\n', '\n', '        EthReceived(_buyer, _amountWei);\n', '    }\n', '\n', '    // Calc how much tokens you can buy at current time.\n', '    function weiToTokens(uint256 _amountWei) public constant returns (uint256) {\n', '        return safeMul(_amountWei, tokensPerWei);\n', '    }\n', '\n', '    //----------------------------------------------------------------------\n', '    // Begin of external sales.\n', '\n', '    function externalSales(\n', '        uint8[] _currencies,\n', '        bytes32[] _txIdSha3,\n', '        address[] _buyers,\n', '        uint256[] _amountsWei,\n', '        uint256[] _tokensE18\n', '    ) public ifNotPaused canNotify {\n', '\n', '        require(_currencies.length > 0);\n', '        require(_currencies.length == _txIdSha3.length);\n', '        require(_currencies.length == _buyers.length);\n', '        require(_currencies.length == _amountsWei.length);\n', '        require(_currencies.length == _tokensE18.length);\n', '\n', '        for (uint i = 0; i < _txIdSha3.length; i++) {\n', '            _externalSaleSha3(\n', '                Currency(_currencies[i]),\n', '                _txIdSha3[i],\n', '                _buyers[i],\n', '                _amountsWei[i],\n', '                _tokensE18[i]\n', '            );\n', '        }\n', '    }\n', '\n', '    function _externalSaleSha3(\n', '        Currency _currency,\n', '        bytes32 _txIdSha3, // To get bytes32 use keccak256(txId) OR sha3(txId)\n', '        address _buyer,\n', '        uint256 _amountWei,\n', '        uint256 _tokensE18\n', '    ) internal {\n', '\n', '        require(_buyer > 0 && _amountWei > 0 && _tokensE18 > 0);\n', '\n', '        var txsByCur = externalTxs[uint8(_currency)];\n', '\n', '        // If this foreign transaction has been already processed in this contract.\n', '        require(txsByCur[_txIdSha3] == 0);\n', '\n', '        totalInWei = safeAdd(totalInWei, _amountWei);\n', '        require(totalInWei <= maxCapWei); // Max cap should not be reached yet.\n', '\n', '        require(token.sell(_buyer, _tokensE18)); // Transfer tokens to buyer.\n', '        totalTokensSold = safeAdd(totalTokensSold, _tokensE18);\n', '        totalExternalSales++;\n', '\n', '        txsByCur[_txIdSha3] = _tokensE18;\n', '        ExternalSale(_currency, _txIdSha3, _buyer, _amountWei, _tokensE18);\n', '    }\n', '\n', '    // Get id of currency enum. --------------------------------------------\n', '\n', '    function btcId() public constant returns (uint8) {\n', '        return uint8(Currency.BTC);\n', '    }\n', '\n', '    function ltcId() public constant returns (uint8) {\n', '        return uint8(Currency.LTC);\n', '    }\n', '\n', '    function zecId() public constant returns (uint8) {\n', '        return uint8(Currency.ZEC);\n', '    }\n', '\n', '    function dashId() public constant returns (uint8) {\n', '        return uint8(Currency.DASH);\n', '    }\n', '\n', '    function wavesId() public constant returns (uint8) {\n', '        return uint8(Currency.WAVES);\n', '    }\n', '\n', '    function usdId() public constant returns (uint8) {\n', '        return uint8(Currency.USD);\n', '    }\n', '\n', '    function eurId() public constant returns (uint8) {\n', '        return uint8(Currency.EUR);\n', '    }\n', '\n', '    // Get token count by transaction id. ----------------------------------\n', '\n', '    function _tokensByTx(Currency _currency, string _txId) internal constant returns (uint256) {\n', '        return tokensByTx(uint8(_currency), _txId);\n', '    }\n', '\n', '    function tokensByTx(uint8 _currency, string _txId) public constant returns (uint256) {\n', '        return externalTxs[_currency][keccak256(_txId)];\n', '    }\n', '\n', '    function tokensByBtcTx(string _txId) public constant returns (uint256) {\n', '        return _tokensByTx(Currency.BTC, _txId);\n', '    }\n', '\n', '    function tokensByLtcTx(string _txId) public constant returns (uint256) {\n', '        return _tokensByTx(Currency.LTC, _txId);\n', '    }\n', '\n', '    function tokensByZecTx(string _txId) public constant returns (uint256) {\n', '        return _tokensByTx(Currency.ZEC, _txId);\n', '    }\n', '\n', '    function tokensByDashTx(string _txId) public constant returns (uint256) {\n', '        return _tokensByTx(Currency.DASH, _txId);\n', '    }\n', '\n', '    function tokensByWavesTx(string _txId) public constant returns (uint256) {\n', '        return _tokensByTx(Currency.WAVES, _txId);\n', '    }\n', '\n', '    function tokensByUsdTx(string _txId) public constant returns (uint256) {\n', '        return _tokensByTx(Currency.USD, _txId);\n', '    }\n', '\n', '    function tokensByEurTx(string _txId) public constant returns (uint256) {\n', '        return _tokensByTx(Currency.EUR, _txId);\n', '    }\n', '\n', '    // End of external sales.\n', '    //----------------------------------------------------------------------\n', '\n', '    function totalSales() public constant returns (uint256) {\n', '        return safeAdd(totalEthSales, totalExternalSales);\n', '    }\n', '\n', '    function isMaxCapReached() public constant returns (bool) {\n', '        return totalInWei >= maxCapWei;\n', '    }\n', '\n', '    function isSaleOn() public constant returns (bool) {\n', '        uint _now = getNow();\n', '        return startTime <= _now && _now <= endTime;\n', '    }\n', '\n', '    function isSaleOver() public constant returns (bool) {\n', '        return getNow() > endTime;\n', '    }\n', '\n', '    function isFinalized() public constant returns (bool) {\n', '        return finalizedTime > 0;\n', '    }\n', '\n', '    /*\n', '     * Finalize the crowdsale. Raised money can be sent to beneficiary only if crowdsale hit end time or max cap.\n', '     */\n', '    function finalize() public onlyOwner {\n', '\n', '        // Cannot finalise before end day of crowdsale until max cap is reached.\n', '        require(isMaxCapReached() || isSaleOver());\n', '\n', '        beneficiary.transfer(this.balance);\n', '\n', '        finalizedTime = getNow();\n', '    }\n', '}\n', '\n', 'contract XPresale is CommonBsPresale {\n', '\n', '    function XPresale() public CommonBsPresale(\n', '        0x625615dCb1b33C4c5F28f48609e46B0727cfB451, // TODO address _token\n', '        0xE3E9F66E5Ebe9E961662da34FF9aEA95c6795fd0  // TODO address _beneficiary\n', '    ) {}\n', '}']