['pragma solidity ^0.4.19;\n', '\n', '/*\n', '* LooksCoin token sale contract\n', '*\n', '* Refer to https://lookrev.com/tokensale/ for more information.\n', '* \n', '* Developer: LookRev\n', '*\n', '*/\n', '\n', '/*\n', ' * ERC20 Token Standard\n', ' */\n', 'contract ERC20 {\n', 'event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', 'event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', 'uint256 public totalSupply;\n', 'function balanceOf(address _owner) constant public returns (uint256 balance);\n', 'function transfer(address _to, uint256 _value) public returns (bool success);\n', 'function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', 'function approve(address _spender, uint256 _value) public returns (bool success);\n', 'function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '}\n', '\n', '/**\n', '* Provides methods to safely add, subtract and multiply uint256 numbers.\n', '*/\n', 'contract SafeMath {\n', '    /**\n', '     * Add two uint256 values, revert in case of overflow.\n', '     *\n', '     * @param a first value to add\n', '     * @param b second value to add\n', '     * @return a + b\n', '     */\n', '    function safeAdd(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Subtract one uint256 value from another, throw in case of underflow.\n', '     *\n', '     * @param a value to subtract from\n', '     * @param b value to subtract\n', '     * @return a - b\n', '     */\n', '    function safeSub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * Multiply two uint256 values, throw in case of overflow.\n', '     *\n', '     * @param a first value to multiply\n', '     * @param b second value to multiply\n', '     * @return a * b\n', '     */\n', '    function safeMul(uint256 a, uint256 b) internal returns (uint256) {\n', '        if (a == 0 || b == 0) return 0;\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Divid uint256 values, throw in case of overflow.\n', '     *\n', '     * @param a first value numerator\n', '     * @param b second value denominator\n', '     * @return a / b\n', '     */\n', '    function safeDiv(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b != 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '}\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Ownable {\n', '    address owner;\n', '    address newOwner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Allows execution by the owner only.\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transferring the contract ownership to the new owner.\n', '     *\n', '     * @param _newOwner new contractor owner\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        if (_newOwner != 0x0) {\n', '          newOwner = _newOwner;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Accept the contract ownership by the new owner.\n', '     *\n', '     */\n', '    function acceptOwnership() {\n', '        require(msg.sender == newOwner);\n', '        owner = newOwner;\n', '        OwnershipTransferred(owner, newOwner);\n', '        newOwner = 0x0;\n', '    }\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '}\n', '\n', '/**\n', '* Standard Token Smart Contract\n', '*/\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the numbers of tokens belonging\n', '     * to these token holders.\n', '     */\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the mapping of addresses of\n', '     * spenders to the allowances set by these token holders to these spenders.\n', '     */\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the mapping of token amount spent.\n', '     * Use by the token holders to spend their utility tokens.\n', '     */\n', '    mapping (address => mapping (address => uint256)) spentamount;\n', '\n', '    /**\n', '     * Mapping of the addition of the addresse of buyers.\n', '     */\n', '    mapping (address => bool) buyerAppended;\n', '\n', '    /**\n', '     * Mapping of the addition of addresses of buyers.\n', '     */\n', '    address[] buyers;\n', '\n', '    /**\n', '     * Mapping of the addresses of VIP token holders.\n', '     */\n', '    address[] vips;\n', '\n', '    /**\n', '    * Mapping for VIP rank for qualified token holders\n', '    * Higher VIP ranking (with earlier timestamp) has higher bidding priority when\n', '    * competing for the same product or service on platform. \n', '    * Higher VIP ranking address can outbid other lower ranking addresses only once per \n', '    * selling window or promotion period.\n', '    * Usage of the VIP ranking and bid priority will be described on token website.\n', '    */\n', '    mapping (address => uint256) viprank;\n', '\n', '    /**\n', '     * Get number of tokens currently belonging to given owner.\n', '     *\n', '     * @param _owner address to get number of tokens currently belonging to the\n', '     *        owner of\n', '     * @return number of tokens currently belonging to the owner of given address\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(_to != 0x0);\n', '        if (balances[msg.sender] < _value) return false;\n', '        balances[msg.sender] = safeSub(balances[msg.sender],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) \n', '        returns (bool success) {\n', '        require(_to != 0x0);\n', '        if(_from == _to) return false;\n', '        if (balances[_from] < _value) return false;\n', '        if (_value > allowed[_from][msg.sender]) return false;\n', '\n', '        balances[_from] = safeSub(balances[_from],_value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allow given spender to transfer given number of tokens from message sender.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _value number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {\n', '           return false;\n', '        }\n', '        if (balances[msg.sender] < _value) {\n', '            return false;\n', '        }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '     }\n', '\n', '    /**\n', '     * Tell how many tokens given spender is currently allowed to transfer from\n', '     * given owner.\n', '     *\n', '     * @param _owner address to get number of tokens allowed to be transferred\n', '     *        from the owner of\n', '     * @param _spender address to get number of tokens allowed to be transferred\n', '     *        by the owner of\n', '     * @return number of tokens given spender is currently allowed to transfer\n', '     *         from given owner\n', '     */\n', '     function allowance(address _owner, address _spender) constant \n', '        returns (uint256 remaining) {\n', '       return allowed[_owner][_spender];\n', '     }\n', '}\n', '\n', '/**\n', ' * LooksCoin Token\n', ' *\n', ' * VIP ranking is recorded at the time when the token holding address first meet VIP coin \n', ' * holding level.\n', ' * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets \n', ' * VIP coin holding level.\n', ' * VIP ranking is used to calculate priority when competing with other bids for the\n', ' * same product or service on the platform. \n', ' * Higher VIP ranking (with earlier timestamp) has higher priority.\n', ' * Higher VIP ranking address can outbid other lower ranking wallet addresse owners only once\n', ' * per selling window or promotion period.\n', ' * Usage of the LooksCoin, VIP ranking and bid priority will be described on token website.\n', ' *\n', ' */\n', 'contract LooksCoin is StandardToken, Ownable {\n', '\n', '    uint256 public constant decimals = 0;\n', '\n', '    /**\n', '     * Minimium contribution to record a VIP rank\n', '     * Token holding address needs have at least 24000 LooksCoin to be ranked as VIP\n', '     * VIP rank can only be set through purchasing tokens\n', '    */\n', '    uint256 public constant VIP_MINIMUM = 24000;\n', '\n', '    /**\n', '     * Initial number of tokens.\n', '     */\n', '    uint256 constant INITIAL_TOKENS_COUNT = 100000000;\n', '\n', '    /**\n', '     * Crowdsale contract address.\n', '     */\n', '    address public tokenSaleContract = 0x0;\n', '\n', '    /**\n', '     * Init Placeholder\n', '     */\n', '    address coinmaster = address(0x33169f40d18c6c2590901db23000D84052a11F54);\n', '\n', '    /**\n', '     * Create new LooksCoin token Smart Contract.\n', '     * Contract is needed in _tokenSaleContract address.\n', '     *\n', '     * @param _tokenSaleContract of crowdsale contract\n', '     *\n', '     */\n', '    function LooksCoin(address _tokenSaleContract) {\n', '        assert(_tokenSaleContract != 0x0);\n', '        owner = coinmaster;\n', '        tokenSaleContract = _tokenSaleContract;\n', '        balances[owner] = INITIAL_TOKENS_COUNT;\n', '        totalSupply = INITIAL_TOKENS_COUNT;\n', '    }\n', '\n', '    /**\n', '     * Get name of this token.\n', '     *\n', '     * @return name of this token\n', '     */\n', '    function name() constant returns (string name) {\n', '      return "LooksCoin";\n', '    }\n', '\n', '    /**\n', '     * Get symbol of this token.\n', '     *\n', '     * @return symbol of this token\n', '     */\n', '    function symbol() constant returns (string symbol) {\n', '      return "LOOKS";\n', '    }\n', '\n', '    /**\n', '     * @dev Set new sale manage contract.\n', '     * May only be called by owner.\n', '     *\n', '     * @param _newSaleManageContract new token sale manage contract.\n', '     */\n', '    function setSaleManageContract(address _newSaleManageContract) {\n', '        require(msg.sender == owner);\n', '        assert(_newSaleManageContract != 0x0);\n', '        tokenSaleContract = _newSaleManageContract;\n', '    }\n', '\n', '    /**\n', '     * Get VIP rank of a given owner.\n', '     * VIP ranking is valid for the lifetime of a token wallet address, \n', '     * as long as it meets VIP holding level.\n', '     *\n', '     * @param _to participant address to get the vip rank\n', '     * @return vip rank of the owner of given address\n', '     */\n', '    function getVIPRank(address _to) constant public returns (uint256 rank) {\n', '        if (balances[_to] < VIP_MINIMUM) {\n', '            return 0;\n', '        }\n', '        return viprank[_to];\n', '    }\n', '\n', '    /**\n', '     * Check and update VIP rank of a given token buyer.\n', '     * Contribution timestamp is recorded for VIP rank\n', '     * Recorded timestamp for VIP ranking should always be earlier than the current time\n', '     *\n', '     * @param _to address to check the vip rank\n', '     * @return rank vip rank of the owner of given address if any\n', '     */\n', '    function updateVIPRank(address _to) returns (uint256 rank) {\n', '        // Contribution timestamp is recorded for VIP rank\n', '        // Recorded timestamp for VIP ranking should always be earlier than current time\n', '        if (balances[_to] >= VIP_MINIMUM && viprank[_to] == 0) {\n', '            viprank[_to] = now;\n', '            vips.push(_to);\n', '        }\n', '        return viprank[_to];\n', '    }\n', '\n', '    event TokenRewardsAdded(address indexed participant, uint256 balance);\n', '    /**\n', '     * Reward participant the tokens they purchased or earned\n', '     *\n', '     * @param _to address to credit tokens to the \n', '     * @param _value number of tokens to transfer to given recipient\n', '     *\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function rewardTokens(address _to, uint256 _value) {\n', '        require(msg.sender == tokenSaleContract || msg.sender == owner);\n', '        assert(_to != 0x0);\n', '        require(_value > 0);\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        totalSupply = safeAdd(totalSupply, _value);\n', '        updateVIPRank(_to);\n', '        TokenRewardsAdded(_to, _value);\n', '    }\n', '\n', '    event SpentTokens(address indexed participant, address indexed recipient, uint256 amount);\n', '    /**\n', '     * Spend given number of tokens for a usage.\n', '     *\n', '     * @param _to address to spend utility tokens at\n', '     * @param _value number of tokens to spend\n', '     * @return true on success, false on error\n', '     */\n', '    function spend(address _to, uint256 _value) public returns (bool success) {\n', '        require(_value > 0);\n', '        assert(_to != 0x0);\n', '        if (balances[msg.sender] < _value) return false;\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        spentamount[msg.sender][_to] = safeAdd(spentamount[msg.sender][_to], _value);\n', '\n', '        SpentTokens(msg.sender, _to, _value);\n', '        if(!buyerAppended[msg.sender]) {\n', '            buyerAppended[msg.sender] = true;\n', '            buyers.push(msg.sender);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function getSpentAmount(address _who, address _to) constant returns (uint256) {\n', '        return spentamount[_who][_to];\n', '    }\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '    /**\n', '     * Burn given number of tokens belonging to message sender.\n', '     * It can be applied by account with address this.tokensaleContract\n', '     *\n', '     * @param _value number of tokens to burn\n', '     * @return true on success, false on error\n', '     */\n', '    function burnTokens(address burner, uint256 _value) public returns (bool success) {\n', '        require(msg.sender == burner || msg.sender == owner);\n', '        assert(burner != 0x0);\n', '        if (_value > totalSupply) return false;\n', '        if (_value > balances[burner]) return false;\n', '        \n', '        balances[burner] = safeSub(balances[burner],_value);\n', '        totalSupply = safeSub(totalSupply,_value);\n', '        Burn(burner, _value);\n', '        return true;\n', '    }\n', '\n', '    function getVIPOwner(uint256 index) constant returns (address) {\n', '        return (vips[index]);\n', '    }\n', '\n', '    function getVIPCount() constant returns (uint256) {\n', '        return vips.length;\n', '    }\n', '\n', '    function getBuyer(uint256 index) constant returns (address) {\n', '        return (buyers[index]);\n', '    }\n', '\n', '    function getBuyersCount() constant returns (uint256) {\n', '        return buyers.length;\n', '    }\n', '}\n', '\n', '/**\n', ' * LooksCoin CrowdSale Contract\n', ' *\n', ' * The token sale controller, allows contributing ether in exchange for LooksCoin.\n', ' * The price (exchange rate with ETH) is 2400 LOOKS per ETH at crowdsale.\n', ' * VIP ranking is recorded at the time when the token holding address first meet VIP coin holding level.\n', ' * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets VIP coin holding level.\n', ' * VIP ranking is used to calculate priority when competing with other bids for the\n', ' * same product or service on the platform. \n', ' * Higher VIP ranking (with earlier timestamp) has higher priority.\n', ' * Higher VIP ranking address can outbid other lower ranking addresses only once per selling window \n', ' * or promotion period.\n', ' * Usage of the LooksCoin, VIP ranking and bid priority will be described on token website.\n', ' *\n', ' * LooksCoin CrowdSale Bonus\n', ' *******************************************************************************************************************\n', ' * First Ten (10) VIP token holders get 20% bonus of the LOOKS tokens in their VIP addresses\n', ' * Eleven (11th) to Fifty (50th) VIP token holders get 10% bonus of the LOOKS tokens in their VIP addresses\n', ' * Fifty One (51th) to One Hundred (100th) VIP token holders get 5% bonus of the LOOKS tokens in their VIP addresses\n', ' *******************************************************************************************************************\n', ' *\n', ' * Bonus tokens will be distributed by coin master when LooksCoin has 100 VIP rank token wallet addresses\n', ' *\n', ' */\n', 'contract LooksCoinCrowdSale {\n', '    LooksCoin public looksCoin;\n', '    ERC20 public preSaleToken;\n', '\n', '    // initial price in wei (numerator)\n', '    uint256 public constant TOKEN_PRICE_N = 1e18;\n', '    // initial price in wei (denominator)\n', '    uint256 public constant TOKEN_PRICE_D = 2400;\n', '    // 1 ETH = 2,400 LOOKS tokens\n', '\n', '    address saleController = 0x0;\n', '\n', '    // Amount of imported tokens from preSale\n', '    uint256 public importedTokens = 0;\n', '\n', '    // Amount of tokens sold\n', '    uint256 public tokensSold = 0;\n', '\n', '    /**\n', '     * Address of the owner of this smart contract.\n', '     */\n', '    address fundstorage = 0x0;\n', '\n', '    /**\n', '     * States of the crowdsale contract.\n', '     */\n', '    enum State{\n', '        Pause,\n', '        Init,\n', '        Running,\n', '        Stopped,\n', '        Migrated\n', '    }\n', '\n', '    State public currentState = State.Running;    \n', '\n', '    /**\n', '     * Modifier.\n', '     */\n', '    modifier onCrowdSaleRunning() {\n', '        // Checks, if CrowdSale is running and has not been paused\n', '        require(currentState == State.Running);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Create new LOOKS token Smart Contract, make message sender to be the\n', '     * owner of smart contract, issue given number of tokens and give them to\n', '     * message sender.\n', '     */\n', '    function LooksCoinCrowdSale() {\n', '        saleController = msg.sender;\n', '        fundstorage = msg.sender;\n', '        looksCoin = new LooksCoin(this);\n', '\n', '        preSaleToken = ERC20(0x253C7dd074f4BaCb305387F922225A4f737C08bd);\n', '    }\n', '\n', '    /**\n', '    * @dev Set new state\n', '    * @param _newState Value of new state\n', '    */\n', '    function setState(State _newState)\n', '    {\n', '        require(msg.sender == saleController);\n', '        currentState = _newState;\n', '    }\n', '\n', '    /**\n', '     * @dev Set new token sale controller.\n', '     * May only be called by sale controller.\n', '     *\n', '     * @param _newSaleController new token sale controller.\n', '     */\n', '    function setSaleController(address _newSaleController) {\n', '        require(msg.sender == saleController);\n', '        assert(_newSaleController != 0x0);\n', '        saleController = _newSaleController;\n', '    }\n', '\n', '    /**\n', '     * Set new wallet address for the smart contract.\n', '     * May only be called by smart contract owner.\n', '     *\n', '     * @param _fundstorage new wallet address of the smart contract\n', '     */\n', '    function setWallet(address _fundstorage) {\n', '        require(msg.sender == saleController);\n', '        assert(_fundstorage != 0x0);\n', '        fundstorage = _fundstorage;\n', '        WalletUpdated(fundstorage);\n', '    }\n', '    event WalletUpdated(address newWallet);\n', '\n', '    /**\n', "    * saves info if account's tokens were imported from pre-CrowdSale\n", '    */\n', '    mapping (address => bool) private importedFromPreSale;\n', '\n', '    event TokensImport(address indexed participant, uint256 tokens, uint256 totalImport);\n', '    /**\n', "    * Imports account's tokens from pre-Sale. \n", '    * It can be done only by account owner or CrowdSale manager\n', '    * @param _account Address of account which tokens will be imported\n', '    */\n', '    function importTokens(address _account) returns (bool success) {\n', '        // only token holder or manager can do import\n', '        require(currentState == State.Running);\n', '        require(msg.sender == saleController || msg.sender == _account);\n', '        require(!importedFromPreSale[_account]);\n', '\n', '        // Token decimals in PreSale was 18\n', '        uint256 preSaleBalance = preSaleToken.balanceOf(_account) / TOKEN_PRICE_N;\n', '\n', '        if (preSaleBalance == 0) return false;\n', '\n', '        looksCoin.rewardTokens(_account, preSaleBalance);\n', '        importedTokens = importedTokens + preSaleBalance;\n', '        importedFromPreSale[_account] = true;\n', '        TokensImport(_account, preSaleBalance, importedTokens);\n', '        return true;\n', '    }\n', '\n', '    // fallback\n', '    function() public payable {\n', '        buyTokens();\n', '    }\n', '\n', '    event TokensBought(address indexed buyer, uint256 ethers, uint256 tokens, uint256 tokensSold);\n', '    /**\n', '     * Accept ethers to buy tokens during the token sale\n', '     * Minimium holdings to receive a VIP rank is 24000 LooksCoin\n', '     */\n', '    function buyTokens() payable returns (uint256 amount)\n', '    {\n', '        require(currentState == State.Running);\n', '        assert(msg.sender != 0x0);\n', '        require(msg.value > 0);\n', '\n', '        // Calculate number of tokens for contributed wei\n', '        uint256 tokens = msg.value * TOKEN_PRICE_D / TOKEN_PRICE_N;\n', '        if (tokens == 0) return 0;\n', '\n', '        looksCoin.rewardTokens(msg.sender, tokens);\n', '        tokensSold = tokensSold + tokens;\n', '\n', '        // Transfer the contributed ethers to the crowdsale fundstorage\n', '        assert(fundstorage.send(msg.value));\n', '        TokensBought(msg.sender, msg.value, tokens, tokensSold);\n', '        return tokens;\n', '    }\n', '}']