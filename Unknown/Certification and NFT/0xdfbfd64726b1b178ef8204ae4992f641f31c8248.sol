['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * Eloplay Crowdsale Token Contract\n', ' * @author Eloplay team (2017)\n', ' * The MIT Licence\n', ' */\n', '\n', '\n', '/**\n', ' * Safe maths, borrowed from OpenZeppelin\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '     * Add a number to another number, checking for overflows\n', '     *\n', '     * @param a           first number\n', '     * @param b           second number\n', '     * @return            sum of a + b\n', '     */\n', '     function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '     }\n', '\n', '    /**\n', '     * Subtract a number from another number, checking for underflows\n', '     *\n', '     * @param a           first number\n', '     * @param b           second number\n', '     * @return            a - b\n', '     */\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * Owned contract gives ownership checking\n', ' */\n', 'contract Owned {\n', '\n', '    /**\n', '     * Current contract owner\n', '     */\n', '    address public owner;\n', '    /**\n', '     * New owner / pretender\n', '     */\n', '    address public newOwner;\n', '\n', '    /**\n', '     * Event fires when ownership is transferred and accepted\n', '     *\n', '     * @param _from         initial owner\n', '     * @param _to           new owner\n', '     */\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    /**\n', '     * Owned contract constructor\n', '     */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Modifier - used to check actions allowed only for contract owner\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Request to change ownership (called by current owner)\n', '     *\n', '     * @param _newOwner         address to transfer ownership to\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '     * Accept ownership request, works only if called by new owner\n', '     */\n', '    function acceptOwnership() {\n', '        // Avoid multiple events triggering in case of several calls from owner\n', '        if (msg.sender == newOwner && owner != newOwner) {\n', '            OwnershipTransferred(owner, newOwner);\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * ERC20 Token, with the addition of symbol, name and decimals\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Token {\n', '    /**\n', '     * Use SafeMath to check over/underflows\n', '     */\n', '    using SafeMath for uint;\n', '\n', '    /**\n', '     * Total Supply\n', '     */\n', '    uint256 public totalSupply = 0;\n', '\n', '    /**\n', '     * Balances for each account\n', '     */\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    /**\n', '     * Owner of account approves the transfer of an amount to another account\n', '     */\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '\n', '    /**\n', '     * Event fires when tokens are transferred\n', '     *\n', '     * @param _from         spender address\n', '     * @param _to           target address\n', '     * @param _value        amount of tokens\n', '     */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    /**\n', '     * Event fires when spending of tokens are approved\n', '     *\n', '     * @param _owner        owner address\n', '     * @param _spender      spender address\n', '     * @param _value        amount of allowed tokens\n', '     */\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', "     * Transfer the balance from owner's account to another account\n", '     *\n', '     * @param _to         target address\n', '     * @param _amount     amount of tokens\n', '     * @return            true on success\n', '     */\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balanceOf[msg.sender] >= _amount                // User has balance\n', '            && _amount > 0                                 // Non-zero transfer\n', '            && balanceOf[_to] + _amount > balanceOf[_to]     // Overflow check\n', '        ) {\n', '            balanceOf[msg.sender] -= _amount;\n', '            balanceOf[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Allow _spender to withdraw from your account, multiple times, up to the\n', '     * _value amount. If this function is called again it overwrites the\n', '     * current allowance with _value.\n', '     *\n', '     * @param _spender    spender address\n', '     * @param _amount     amount of tokens\n', '     * @return            true on success\n', '     */\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowance[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * Spender of tokens transfer an amount of tokens from the token owner's\n", "     * balance to the spender's account. The owner of the tokens must already\n", '     * have approve(...)-d this transfer\n', '     *\n', '     * @param _from       spender address\n', '     * @param _to         target address\n', '     * @param _amount     amount of tokens\n', '     * @return            true on success\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {\n', '        if (balanceOf[_from] >= _amount                  // From a/c has balance\n', '            && allowance[_from][msg.sender] >= _amount    // Transfer approved\n', '            && _amount > 0                              // Non-zero transfer\n', '            && balanceOf[_to] + _amount > balanceOf[_to]  // Overflow check\n', '        ) {\n', '            balanceOf[_from] -= _amount;\n', '            allowance[_from][msg.sender] -= _amount;\n', '            balanceOf[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract EloPlayToken is ERC20Token, Owned {\n', '\n', '    /**\n', '     * Token data\n', '     */\n', '    string public constant symbol = "ELT";\n', '    string public constant name = "EloPlayToken";\n', '    uint8 public constant decimals = 18;\n', '\n', '    /**\n', '     * Wallet where invested Ethers will be sent\n', '     */\n', '    address public TARGET_ADDRESS;\n', '\n', '    /**\n', '     * Wallet where bonus tokens will be sent\n', '     */\n', '    address public TARGET_TOKENS_ADDRESS;\n', '\n', '    /**\n', '     * Start/end timestamp (unix)\n', '     */\n', '    uint256 public START_TS;\n', '    uint256 public END_TS;\n', '\n', '    /**\n', '     * CAP in ether - may be changed before crowdsale starts to match actual ETH/USD rate\n', '     */\n', '    uint256 public CAP;\n', '\n', '    /**\n', '     * Usd/eth rate at start of ICO. Used for raised funds calculations\n', '     */\n', '    uint256 public USDETHRATE;\n', '\n', '    /**\n', '     * Is contract halted (in case of emergency)\n', '     * Default value will be false (not halted)\n', '     */\n', '    bool public halted;\n', '\n', '    /**\n', '     * Total Ethers invested\n', '     */\n', '    uint256 public totalEthers;\n', '\n', '    /**\n', '     * Event fires when tokens are bought\n', '     *\n', '     * @param buyer                     tokens buyer\n', '     * @param ethers                    total Ethers invested (in wei)\n', '     * @param new_ether_balance         new Ethers balance (in wei)\n', '     * @param tokens                    tokens bought for transaction\n', '     * @param target_address_tokens     additional tokens generated for multisignature wallet\n', '     * @param new_total_supply          total tokens bought\n', '     * @param buy_price                 tokens/ETH rate for transaction\n', '     */\n', '    event TokensBought(address indexed buyer, uint256 ethers,\n', '        uint256 new_ether_balance, uint256 tokens, uint256 target_address_tokens,\n', '        uint256 new_total_supply, uint256 buy_price);\n', '\n', '    /**\n', '     * Event fires when tokens are bought\n', '     *\n', '     * @param backer                    buyer\n', '     * @param amount                    total Ethers invested (in wei)\n', '     * @param isContribution            always true in our case\n', '     */\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '\n', '    /**\n', '     * EloPlayToken contract constructor\n', '     *\n', '     * @param _start_ts         crowdsale start timestamp (unix)\n', '     * @param _end_ts           crowdsale end timestamp (unix)\n', '     * @param _cap              crowdsale upper cap (in wei)\n', '     * @param _target_address   multisignature wallet where Ethers will be sent to\n', '     * @param _target_tokens_address   account where 30% of tokens will be sent to\n', '     * @param _usdethrate       USD to ETH rate\n', '     */\n', '    function EloPlayToken(uint256 _start_ts, uint256 _end_ts, uint256 _cap, address _target_address,  address _target_tokens_address, uint256 _usdethrate) {\n', '        START_TS        = _start_ts;\n', '        END_TS          = _end_ts;\n', '        CAP             = _cap;\n', '        USDETHRATE      = _usdethrate;\n', '        TARGET_ADDRESS  = _target_address;\n', '        TARGET_TOKENS_ADDRESS  = _target_tokens_address;\n', '    }\n', '\n', '    /**\n', '     * Update cap before crowdsale starts\n', '     *\n', '     * @param _cap          new crowdsale upper cap (in wei)\n', '     * @param _usdethrate   USD to ETH rate\n', '     */\n', '    function updateCap(uint256 _cap, uint256 _usdethrate) onlyOwner {\n', "        // Don't process if halted\n", '        require(!halted);\n', '        // Make sure crowdsale isnt started yet\n', '        require(now < START_TS);\n', '        CAP = _cap;\n', '        USDETHRATE = _usdethrate;\n', '    }\n', '\n', '    /**\n', '     * Get raised USD based on USDETHRATE\n', '     *\n', '     * @return            USD raised value\n', '     */\n', '    function totalUSD() constant returns (uint256) {\n', '        return totalEthers * USDETHRATE;\n', '    }\n', '\n', '    /**\n', '     * Get tokens per ETH for current date/time\n', '     *\n', '     * @return            current tokens/ETH rate\n', '     */\n', '    function buyPrice() constant returns (uint256) {\n', '        return buyPriceAt(now);\n', '    }\n', '\n', '    /**\n', '     * Get tokens per ETH for given date/time\n', '     *\n', '     * @param _at         timestamp (unix)\n', '     * @return            tokens/ETH rate for given timestamp\n', '     */\n', '    function buyPriceAt(uint256 _at) constant returns (uint256) {\n', '        if (_at < START_TS) {\n', '            return 0;\n', '        } else if (_at < START_TS + 3600) {\n', '            // 1st hour = 10000 + 20% = 12000\n', '            return 12000;\n', '        } else if (_at < START_TS + 3600 * 24) {\n', '            // 1st day = 10000 + 15% = 11500\n', '            return 11500;\n', '        } else if (_at < START_TS + 3600 * 24 * 7) {\n', '            // 1st week = 10000 + 10% = 11000\n', '            return 11000;\n', '        } else if (_at < START_TS + 3600 * 24 * 7 * 2) {\n', '            // 2nd week = 10000 + 5% = 10500\n', '            return 10500;\n', '        } else if (_at <= END_TS) {\n', '            // More than 2 weeks = 10000\n', '            return 10000;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Halt transactions in case of emergency\n', '     */\n', '    function halt() onlyOwner {\n', '        require(!halted);\n', '        halted = true;\n', '    }\n', '\n', '    /**\n', '     * Unhalt halted contract\n', '     */\n', '    function unhalt() onlyOwner {\n', '        require(halted);\n', '        halted = false;\n', '    }\n', '\n', '    /**\n', '     * Owner to add precommitment funding token balance before the crowdsale commences\n', '     * Used for pre-sale commitments, added manually\n', '     *\n', '     * @param _participant         address that will receive tokens\n', '     * @param _balance             number of tokens\n', '     * @param _ethers         Ethers value (needed for stats)\n', '     *\n', '     */\n', '    function addPrecommitment(address _participant, uint256 _balance, uint256 _ethers) onlyOwner {\n', '        require(now < START_TS);\n', '        // Minimum value = 1ELT\n', '        // Since we are using 18 decimals for token\n', '        require(_balance >= 1 ether);\n', '\n', "        // To avoid overflow, first divide then multiply (to clearly show 70%+30%, result wasn't precalculated)\n", '        uint additional_tokens = _balance / 70 * 30;\n', '\n', '        balanceOf[_participant] = balanceOf[_participant].add(_balance);\n', '        balanceOf[TARGET_TOKENS_ADDRESS] = balanceOf[TARGET_TOKENS_ADDRESS].add(additional_tokens);\n', '\n', '        totalSupply = totalSupply.add(_balance);\n', '        totalSupply = totalSupply.add(additional_tokens);\n', '\n', '        // Add ETH raised to total\n', '        totalEthers = totalEthers.add(_ethers);\n', '\n', '        Transfer(0x0, _participant, _balance);\n', '        Transfer(0x0, TARGET_TOKENS_ADDRESS, additional_tokens);\n', '    }\n', '\n', '    /**\n', '     * Buy tokens from the contract\n', '     */\n', '    function () payable {\n', '        proxyPayment(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Exchanges can buy on behalf of participant\n', '     *\n', '     * @param _participant         address that will receive tokens\n', '     */\n', '    function proxyPayment(address _participant) payable {\n', "        // Don't process if halted\n", '        require(!halted);\n', '        // No contributions before the start of the crowdsale\n', '        require(now >= START_TS);\n', '        // No contributions after the end of the crowdsale\n', '        require(now <= END_TS);\n', '        // No contributions after CAP is reached\n', '        require(totalEthers < CAP);\n', '        // Require 0.1 eth minimum\n', '        require(msg.value >= 0.1 ether);\n', '\n', '        // Add ETH raised to total\n', '        totalEthers = totalEthers.add(msg.value);\n', '        // Cannot exceed cap more than 0.1 ETH (to be able to finish ICO if CAP - totalEthers < 0.1)\n', '        require(totalEthers < CAP + 0.1 ether);\n', '\n', '        // What is the ELT to ETH rate\n', '        uint256 _buyPrice = buyPrice();\n', '\n', '        // Calculate #ELT - this is safe as _buyPrice is known\n', '        // and msg.value is restricted to valid values\n', '        uint tokens = msg.value * _buyPrice;\n', '\n', '        // Check tokens > 0\n', '        require(tokens > 0);\n', '        // Compute tokens for foundation; user tokens = 70%; TARGET_ADDRESS = 30%\n', '        // Number of tokens restricted so maths is safe\n', "        // To clearly show 70%+30%, result wasn't precalculated\n", '        uint additional_tokens = tokens * 30 / 70;\n', '\n', '        // Add to total supply\n', '        totalSupply = totalSupply.add(tokens);\n', '        totalSupply = totalSupply.add(additional_tokens);\n', '\n', '        // Add to balances\n', '        balanceOf[_participant] = balanceOf[_participant].add(tokens);\n', '        balanceOf[TARGET_TOKENS_ADDRESS] = balanceOf[TARGET_TOKENS_ADDRESS].add(additional_tokens);\n', '\n', '        // Log events\n', '        TokensBought(_participant, msg.value, totalEthers, tokens, additional_tokens,\n', '            totalSupply, _buyPrice);\n', '        FundTransfer(_participant, msg.value, true);\n', '        Transfer(0x0, _participant, tokens);\n', '        Transfer(0x0, TARGET_TOKENS_ADDRESS, additional_tokens);\n', '\n', '        // Move the funds to a safe wallet\n', '        TARGET_ADDRESS.transfer(msg.value);\n', '    }\n', '\n', '    /**\n', "     * Transfer the balance from owner's account to another account, with a\n", '     * check that the crowdsale is finalized\n', '     *\n', '     * @param _to                tokens receiver\n', '     * @param _amount            tokens amount\n', '     * @return                   true on success\n', '     */\n', '    function transfer(address _to, uint _amount) returns (bool success) {\n', '        // Cannot transfer before crowdsale ends or cap reached\n', '        require(now > END_TS || totalEthers >= CAP);\n', '        // Standard transfer\n', '        return super.transfer(_to, _amount);\n', '    }\n', '\n', '    /**\n', "     * Spender of tokens transfer an amount of tokens from the token owner's\n", '     * balance to another account, with a check that the crowdsale is\n', '     * finalized\n', '     *\n', '     * @param _from              tokens sender\n', '     * @param _to                tokens receiver\n', '     * @param _amount            tokens amount\n', '     * @return                   true on success\n', '     */\n', '    function transferFrom(address _from, address _to, uint _amount)\n', '            returns (bool success) {\n', '        // Cannot transfer before crowdsale ends or cap reached\n', '        require(now > END_TS || totalEthers >= CAP);\n', '        // Standard transferFrom\n', '        return super.transferFrom(_from, _to, _amount);\n', '    }\n', '\n', '    /**\n', '     * Owner can transfer out any accidentally sent ERC20 tokens\n', '     *\n', '     * @param _tokenAddress       tokens address\n', '     * @param _amount             tokens amount\n', '     * @return                   true on success\n', '     */\n', '    function transferAnyERC20Token(address _tokenAddress, uint _amount)\n', '      onlyOwner returns (bool success) {\n', '        return ERC20Token(_tokenAddress).transfer(owner, _amount);\n', '    }\n', '}']