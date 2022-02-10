['pragma solidity ^0.4.2;\n', '\n', 'contract Token {\n', '    /* Public variables of the token */\n', '    string public standard;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public _totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* ERC20 Events */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function Token(uint256 initialSupply, string _standard, string _name, string _symbol, uint8 _decimals) {\n', '        _totalSupply = initialSupply;\n', '        balanceOf[this] = initialSupply;\n', '        standard = _standard;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /* Get burnable total supply */\n', '    function totalSupply() constant returns(uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * Transfer token logic\n', '     * @param _from The address to transfer from.\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '        balanceOf[_from] -= _value;\n', '\n', '        balanceOf[_to] += _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '    function transferFromInternal(address _from, address _to, uint256 _value) internal returns (bool success) {\n', '        require(_value >= allowance[_from][msg.sender]);   // Check allowance\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        return transferInternal(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract ICO {\n', '    uint256 public PRE_ICO_SINCE = 1500303600;                     // 07/17/2017 @ 15:00 (UTC)\n', '    uint256 public PRE_ICO_TILL = 1500476400;                      // 07/19/2017 @ 15:00 (UTC)\n', '    uint256 public constant PRE_ICO_BONUS_RATE = 70;\n', '    uint256 public constant PRE_ICO_SLGN_LESS = 5000 ether;                 // upper limit for pre ico is 5k ether\n', '\n', '    uint256 public ICO_SINCE = 1500994800;                         // 07/25/2017 @ 9:00am (UTC)\n', '    uint256 public ICO_TILL = 1502809200;                          // 08/15/2017 @ 9:00am (UTC)\n', '    uint256 public constant ICO_BONUS1_SLGN_LESS = 20000 ether;                // bonus 1 will work only if 20000 eth were collected during first phase of ico\n', '    uint256 public constant ICO_BONUS1_RATE = 30;                           // bonus 1 rate\n', '    uint256 public constant ICO_BONUS2_SLGN_LESS = 50000 ether;                // bonus 1 will work only if 50000 eth were collected during second phase of ico\n', '    uint256 public constant ICO_BONUS2_RATE = 15; // bonus 2 rate\n', '\n', '    uint256 public totalSoldSlogns;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event BonusEarned(address target, uint256 bonus);\n', '\n', '    /**\n', '     * Calculate amount of premium bonuses\n', '     * @param icoStep identifies is it pre-ico (equals 0) or ico (equals 1)\n', '     * @param totalSoldSlogns total amount of already sold slogn tokens.\n', '     * @param soldSlogns total amount sold slogns in current transaction.\n', '     */\n', '    function calculateBonus(uint8 icoStep, uint256 totalSoldSlogns, uint256 soldSlogns) returns (uint256) {\n', '        if(icoStep == 1) {\n', '            // pre ico\n', '            return soldSlogns / 100 * PRE_ICO_BONUS_RATE;\n', '        }\n', '        else if(icoStep == 2) {\n', '            // ico\n', '            if(totalSoldSlogns > ICO_BONUS1_SLGN_LESS + ICO_BONUS2_SLGN_LESS) {\n', '                return 0;\n', '            }\n', '\n', '            uint256 availableForBonus1 = ICO_BONUS1_SLGN_LESS - totalSoldSlogns;\n', '\n', '            uint256 tmp = soldSlogns;\n', '            uint256 bonus = 0;\n', '\n', '            uint256 tokensForBonus1 = 0;\n', '\n', '            if(availableForBonus1 > 0 && availableForBonus1 <= ICO_BONUS1_SLGN_LESS) {\n', '                tokensForBonus1 = tmp > availableForBonus1 ? availableForBonus1 : tmp;\n', '\n', '                bonus += tokensForBonus1 / 100 * ICO_BONUS1_RATE;\n', '                tmp -= tokensForBonus1;\n', '            }\n', '\n', '            uint256 availableForBonus2 = (ICO_BONUS2_SLGN_LESS + ICO_BONUS1_SLGN_LESS) - totalSoldSlogns - tokensForBonus1;\n', '\n', '            uint256 tokensForBonus2 = 0;\n', '\n', '            if(availableForBonus2 > 0 && availableForBonus2 <= ICO_BONUS2_SLGN_LESS) {\n', '                tokensForBonus2 = tmp > availableForBonus2 ? availableForBonus2 : tmp;\n', '\n', '                bonus += tokensForBonus2 / 100 * ICO_BONUS2_RATE;\n', '                tmp -= tokensForBonus2;\n', '            }\n', '\n', '            return bonus;\n', '        }\n', '\n', '        return 0;\n', '    }\n', '}\n', '\n', 'contract EscrowICO is Token, ICO {\n', '    uint256 public constant MIN_PRE_ICO_SLOGN_COLLECTED = 1000 ether;       // PRE ICO is successful only if sold 10.000.000 slogns\n', '    uint256 public constant MIN_ICO_SLOGN_COLLECTED = 1000 ether;          // ICO is successful only if sold 100.000.000 slogns\n', '\n', '    bool public isTransactionsAllowed;\n', '\n', '    uint256 public totalSoldSlogns;\n', '\n', '    mapping (address => uint256) public preIcoEthers;\n', '    mapping (address => uint256) public icoEthers;\n', '\n', '    event RefundEth(address indexed owner, uint256 value);\n', '    event IcoFinished();\n', '\n', '    function EscrowICO() {\n', '        isTransactionsAllowed = false;\n', '    }\n', '\n', '    function getIcoStep(uint256 time) returns (uint8 step) {\n', '        if(time >=  PRE_ICO_SINCE && time <= PRE_ICO_TILL) {\n', '            return 1;\n', '        }\n', '        else if(time >= ICO_SINCE && time <= ICO_TILL) {\n', '            // ico shoud fail if collected less than 1000 slogns during pre ico\n', '            if(totalSoldSlogns >= MIN_PRE_ICO_SLOGN_COLLECTED) {\n', '                return 2;\n', '            }\n', '        }\n', '\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * officially finish ICO, only allowed after ICO is ended\n', '     */\n', '    function icoFinishInternal(uint256 time) internal returns (bool) {\n', '        if(time <= ICO_TILL) {\n', '            return false;\n', '        }\n', '\n', '        if(totalSoldSlogns >= MIN_ICO_SLOGN_COLLECTED) {\n', '            // burn tokens assigned to smart contract\n', '\n', '            _totalSupply = _totalSupply - balanceOf[this];\n', '\n', '            balanceOf[this] = 0;\n', '\n', '            // allow transactions for everyone\n', '            isTransactionsAllowed = true;\n', '\n', '            IcoFinished();\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * refund ico method\n', '     */\n', '    function refundInternal(uint256 time) internal returns (bool) {\n', '        if(time <= PRE_ICO_TILL) {\n', '            return false;\n', '        }\n', '\n', '        if(totalSoldSlogns >= MIN_PRE_ICO_SLOGN_COLLECTED) {\n', '            return false;\n', '        }\n', '\n', '        uint256 transferedEthers;\n', '\n', '        transferedEthers = preIcoEthers[msg.sender];\n', '\n', '        if(transferedEthers > 0) {\n', '            preIcoEthers[msg.sender] = 0;\n', '\n', '            balanceOf[msg.sender] = 0;\n', '\n', '            msg.sender.transfer(transferedEthers);\n', '\n', '            RefundEth(msg.sender, transferedEthers);\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract SlognToken is Token, EscrowICO {\n', '    string public constant STANDARD = &#39;Slogn v0.1&#39;;\n', '    string public constant NAME = &#39;SLOGN&#39;;\n', '    string public constant SYMBOL = &#39;SLGN&#39;;\n', '    uint8 public constant PRECISION = 14;\n', '\n', '    uint256 public constant TOTAL_SUPPLY = 800000 ether; // initial total supply equals to 8.000.000.000 slogns or 800.000 eths\n', '\n', '    uint256 public constant CORE_TEAM_TOKENS = TOTAL_SUPPLY / 100 * 15;       // 15%\n', '    uint256 public constant ADVISORY_BOARD_TOKENS = TOTAL_SUPPLY / 1000 * 15;       // 1.5%\n', '    uint256 public constant OPENSOURCE_TOKENS = TOTAL_SUPPLY / 1000 * 75;     // 7.5%\n', '    uint256 public constant RESERVE_TOKENS = TOTAL_SUPPLY / 100 * 5;          // 5%\n', '    uint256 public constant BOUNTY_TOKENS = TOTAL_SUPPLY / 100;               // 1%\n', '\n', '    address public advisoryBoardFundManager;\n', '    address public opensourceFundManager;\n', '    address public reserveFundManager;\n', '    address public bountyFundManager;\n', '    address public ethFundManager;\n', '    address public owner;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event BonusEarned(address target, uint256 bonus);\n', '\n', '    /* Modifiers */\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender);\n', '\n', '        _;\n', '    }\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function SlognToken(\n', '    address [] coreTeam,\n', '    address _advisoryBoardFundManager,\n', '    address _opensourceFundManager,\n', '    address _reserveFundManager,\n', '    address _bountyFundManager,\n', '    address _ethFundManager\n', '    )\n', '    Token (TOTAL_SUPPLY, STANDARD, NAME, SYMBOL, PRECISION)\n', '    EscrowICO()\n', '    {\n', '        owner = msg.sender;\n', '\n', '        advisoryBoardFundManager = _advisoryBoardFundManager;\n', '        opensourceFundManager = _opensourceFundManager;\n', '        reserveFundManager = _reserveFundManager;\n', '        bountyFundManager = _bountyFundManager;\n', '        ethFundManager = _ethFundManager;\n', '\n', '        // transfer tokens to core team\n', '        uint256 tokensPerMember = CORE_TEAM_TOKENS / coreTeam.length;\n', '\n', '        for(uint8 i = 0; i < coreTeam.length; i++) {\n', '            transferInternal(this, coreTeam[i], tokensPerMember);\n', '        }\n', '\n', '        // Advisory board fund\n', '        transferInternal(this, advisoryBoardFundManager, ADVISORY_BOARD_TOKENS);\n', '\n', '        // Opensource fund\n', '        transferInternal(this, opensourceFundManager, OPENSOURCE_TOKENS);\n', '\n', '        // Reserve fund\n', '        transferInternal(this, reserveFundManager, RESERVE_TOKENS);\n', '\n', '        // Bounty fund\n', '        transferInternal(this, bountyFundManager, BOUNTY_TOKENS);\n', '    }\n', '\n', '    function buyFor(address _user, uint256 ethers, uint time) internal returns (bool success) {\n', '        require(ethers > 0);\n', '\n', '        uint8 icoStep = getIcoStep(time);\n', '\n', '        require(icoStep == 1 || icoStep == 2);\n', '\n', '        // maximum collected amount for preico is 5000 ether\n', '        if(icoStep == 1 && (totalSoldSlogns + ethers) > 5000 ether) {\n', '            throw;\n', '        }\n', '\n', '        uint256 slognAmount = ethers; // calculates the amount\n', '\n', '        uint256 bonus = calculateBonus(icoStep, totalSoldSlogns, slognAmount);\n', '\n', '        // check for available slogns\n', '        require(balanceOf[this] >= slognAmount + bonus);\n', '\n', '        if(bonus > 0) {\n', '            BonusEarned(_user, bonus);\n', '        }\n', '\n', '        transferInternal(this, _user, slognAmount + bonus);\n', '\n', '        totalSoldSlogns += slognAmount;\n', '\n', '        if(icoStep == 1) {\n', '            preIcoEthers[_user] += ethers;      // fill ethereum used for refund if goal not reached\n', '        }\n', '        if(icoStep == 2) {\n', '            icoEthers[_user] += ethers;      // fill ethereum used for refund if goal not reached\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Buy Slogn tokens\n', '     */\n', '    function buy() payable {\n', '        buyFor(msg.sender, msg.value, block.timestamp);\n', '    }\n', '\n', '    /**\n', '     * Manage ethereum balance\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transferEther(address to, uint256 value) returns (bool success) {\n', '        if(msg.sender != ethFundManager) {\n', '            return false;\n', '        }\n', '\n', '        if(totalSoldSlogns < MIN_PRE_ICO_SLOGN_COLLECTED) {\n', '            return false;\n', '        }\n', '\n', '        if(this.balance < value) {\n', '            return false;\n', '        }\n', '\n', '        to.transfer(value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if(isTransactionsAllowed == false) {\n', '            if(msg.sender != bountyFundManager) {\n', '                return false;\n', '            }\n', '        }\n', '\n', '        return transferInternal(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if(isTransactionsAllowed == false) {\n', '            if(_from != bountyFundManager) {\n', '                return false;\n', '            }\n', '        }\n', '\n', '        return transferFromInternal(_from, _to, _value);\n', '    }\n', '\n', '    function refund() returns (bool) {\n', '        return refundInternal(block.timestamp);\n', '    }\n', '\n', '    function icoFinish() returns (bool) {\n', '        return icoFinishInternal(block.timestamp);\n', '    }\n', '\n', '    function setPreIcoDates(uint256 since, uint256 till) onlyOwner {\n', '        PRE_ICO_SINCE = since;\n', '        PRE_ICO_TILL = till;\n', '    }\n', '\n', '    function setIcoDates(uint256 since, uint256 till) onlyOwner {\n', '        ICO_SINCE = since;\n', '        ICO_TILL = till;\n', '    }\n', '\n', '    function setTransactionsAllowed(bool enabled) onlyOwner {\n', '        isTransactionsAllowed = enabled;\n', '    }\n', '\n', '    function () payable {\n', '        throw;\n', '    }\n', '}']
['pragma solidity ^0.4.2;\n', '\n', 'contract Token {\n', '    /* Public variables of the token */\n', '    string public standard;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public _totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* ERC20 Events */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function Token(uint256 initialSupply, string _standard, string _name, string _symbol, uint8 _decimals) {\n', '        _totalSupply = initialSupply;\n', '        balanceOf[this] = initialSupply;\n', '        standard = _standard;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /* Get burnable total supply */\n', '    function totalSupply() constant returns(uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * Transfer token logic\n', '     * @param _from The address to transfer from.\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '        balanceOf[_from] -= _value;\n', '\n', '        balanceOf[_to] += _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '    function transferFromInternal(address _from, address _to, uint256 _value) internal returns (bool success) {\n', '        require(_value >= allowance[_from][msg.sender]);   // Check allowance\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        return transferInternal(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract ICO {\n', '    uint256 public PRE_ICO_SINCE = 1500303600;                     // 07/17/2017 @ 15:00 (UTC)\n', '    uint256 public PRE_ICO_TILL = 1500476400;                      // 07/19/2017 @ 15:00 (UTC)\n', '    uint256 public constant PRE_ICO_BONUS_RATE = 70;\n', '    uint256 public constant PRE_ICO_SLGN_LESS = 5000 ether;                 // upper limit for pre ico is 5k ether\n', '\n', '    uint256 public ICO_SINCE = 1500994800;                         // 07/25/2017 @ 9:00am (UTC)\n', '    uint256 public ICO_TILL = 1502809200;                          // 08/15/2017 @ 9:00am (UTC)\n', '    uint256 public constant ICO_BONUS1_SLGN_LESS = 20000 ether;                // bonus 1 will work only if 20000 eth were collected during first phase of ico\n', '    uint256 public constant ICO_BONUS1_RATE = 30;                           // bonus 1 rate\n', '    uint256 public constant ICO_BONUS2_SLGN_LESS = 50000 ether;                // bonus 1 will work only if 50000 eth were collected during second phase of ico\n', '    uint256 public constant ICO_BONUS2_RATE = 15; // bonus 2 rate\n', '\n', '    uint256 public totalSoldSlogns;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event BonusEarned(address target, uint256 bonus);\n', '\n', '    /**\n', '     * Calculate amount of premium bonuses\n', '     * @param icoStep identifies is it pre-ico (equals 0) or ico (equals 1)\n', '     * @param totalSoldSlogns total amount of already sold slogn tokens.\n', '     * @param soldSlogns total amount sold slogns in current transaction.\n', '     */\n', '    function calculateBonus(uint8 icoStep, uint256 totalSoldSlogns, uint256 soldSlogns) returns (uint256) {\n', '        if(icoStep == 1) {\n', '            // pre ico\n', '            return soldSlogns / 100 * PRE_ICO_BONUS_RATE;\n', '        }\n', '        else if(icoStep == 2) {\n', '            // ico\n', '            if(totalSoldSlogns > ICO_BONUS1_SLGN_LESS + ICO_BONUS2_SLGN_LESS) {\n', '                return 0;\n', '            }\n', '\n', '            uint256 availableForBonus1 = ICO_BONUS1_SLGN_LESS - totalSoldSlogns;\n', '\n', '            uint256 tmp = soldSlogns;\n', '            uint256 bonus = 0;\n', '\n', '            uint256 tokensForBonus1 = 0;\n', '\n', '            if(availableForBonus1 > 0 && availableForBonus1 <= ICO_BONUS1_SLGN_LESS) {\n', '                tokensForBonus1 = tmp > availableForBonus1 ? availableForBonus1 : tmp;\n', '\n', '                bonus += tokensForBonus1 / 100 * ICO_BONUS1_RATE;\n', '                tmp -= tokensForBonus1;\n', '            }\n', '\n', '            uint256 availableForBonus2 = (ICO_BONUS2_SLGN_LESS + ICO_BONUS1_SLGN_LESS) - totalSoldSlogns - tokensForBonus1;\n', '\n', '            uint256 tokensForBonus2 = 0;\n', '\n', '            if(availableForBonus2 > 0 && availableForBonus2 <= ICO_BONUS2_SLGN_LESS) {\n', '                tokensForBonus2 = tmp > availableForBonus2 ? availableForBonus2 : tmp;\n', '\n', '                bonus += tokensForBonus2 / 100 * ICO_BONUS2_RATE;\n', '                tmp -= tokensForBonus2;\n', '            }\n', '\n', '            return bonus;\n', '        }\n', '\n', '        return 0;\n', '    }\n', '}\n', '\n', 'contract EscrowICO is Token, ICO {\n', '    uint256 public constant MIN_PRE_ICO_SLOGN_COLLECTED = 1000 ether;       // PRE ICO is successful only if sold 10.000.000 slogns\n', '    uint256 public constant MIN_ICO_SLOGN_COLLECTED = 1000 ether;          // ICO is successful only if sold 100.000.000 slogns\n', '\n', '    bool public isTransactionsAllowed;\n', '\n', '    uint256 public totalSoldSlogns;\n', '\n', '    mapping (address => uint256) public preIcoEthers;\n', '    mapping (address => uint256) public icoEthers;\n', '\n', '    event RefundEth(address indexed owner, uint256 value);\n', '    event IcoFinished();\n', '\n', '    function EscrowICO() {\n', '        isTransactionsAllowed = false;\n', '    }\n', '\n', '    function getIcoStep(uint256 time) returns (uint8 step) {\n', '        if(time >=  PRE_ICO_SINCE && time <= PRE_ICO_TILL) {\n', '            return 1;\n', '        }\n', '        else if(time >= ICO_SINCE && time <= ICO_TILL) {\n', '            // ico shoud fail if collected less than 1000 slogns during pre ico\n', '            if(totalSoldSlogns >= MIN_PRE_ICO_SLOGN_COLLECTED) {\n', '                return 2;\n', '            }\n', '        }\n', '\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * officially finish ICO, only allowed after ICO is ended\n', '     */\n', '    function icoFinishInternal(uint256 time) internal returns (bool) {\n', '        if(time <= ICO_TILL) {\n', '            return false;\n', '        }\n', '\n', '        if(totalSoldSlogns >= MIN_ICO_SLOGN_COLLECTED) {\n', '            // burn tokens assigned to smart contract\n', '\n', '            _totalSupply = _totalSupply - balanceOf[this];\n', '\n', '            balanceOf[this] = 0;\n', '\n', '            // allow transactions for everyone\n', '            isTransactionsAllowed = true;\n', '\n', '            IcoFinished();\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * refund ico method\n', '     */\n', '    function refundInternal(uint256 time) internal returns (bool) {\n', '        if(time <= PRE_ICO_TILL) {\n', '            return false;\n', '        }\n', '\n', '        if(totalSoldSlogns >= MIN_PRE_ICO_SLOGN_COLLECTED) {\n', '            return false;\n', '        }\n', '\n', '        uint256 transferedEthers;\n', '\n', '        transferedEthers = preIcoEthers[msg.sender];\n', '\n', '        if(transferedEthers > 0) {\n', '            preIcoEthers[msg.sender] = 0;\n', '\n', '            balanceOf[msg.sender] = 0;\n', '\n', '            msg.sender.transfer(transferedEthers);\n', '\n', '            RefundEth(msg.sender, transferedEthers);\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract SlognToken is Token, EscrowICO {\n', "    string public constant STANDARD = 'Slogn v0.1';\n", "    string public constant NAME = 'SLOGN';\n", "    string public constant SYMBOL = 'SLGN';\n", '    uint8 public constant PRECISION = 14;\n', '\n', '    uint256 public constant TOTAL_SUPPLY = 800000 ether; // initial total supply equals to 8.000.000.000 slogns or 800.000 eths\n', '\n', '    uint256 public constant CORE_TEAM_TOKENS = TOTAL_SUPPLY / 100 * 15;       // 15%\n', '    uint256 public constant ADVISORY_BOARD_TOKENS = TOTAL_SUPPLY / 1000 * 15;       // 1.5%\n', '    uint256 public constant OPENSOURCE_TOKENS = TOTAL_SUPPLY / 1000 * 75;     // 7.5%\n', '    uint256 public constant RESERVE_TOKENS = TOTAL_SUPPLY / 100 * 5;          // 5%\n', '    uint256 public constant BOUNTY_TOKENS = TOTAL_SUPPLY / 100;               // 1%\n', '\n', '    address public advisoryBoardFundManager;\n', '    address public opensourceFundManager;\n', '    address public reserveFundManager;\n', '    address public bountyFundManager;\n', '    address public ethFundManager;\n', '    address public owner;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event BonusEarned(address target, uint256 bonus);\n', '\n', '    /* Modifiers */\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender);\n', '\n', '        _;\n', '    }\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function SlognToken(\n', '    address [] coreTeam,\n', '    address _advisoryBoardFundManager,\n', '    address _opensourceFundManager,\n', '    address _reserveFundManager,\n', '    address _bountyFundManager,\n', '    address _ethFundManager\n', '    )\n', '    Token (TOTAL_SUPPLY, STANDARD, NAME, SYMBOL, PRECISION)\n', '    EscrowICO()\n', '    {\n', '        owner = msg.sender;\n', '\n', '        advisoryBoardFundManager = _advisoryBoardFundManager;\n', '        opensourceFundManager = _opensourceFundManager;\n', '        reserveFundManager = _reserveFundManager;\n', '        bountyFundManager = _bountyFundManager;\n', '        ethFundManager = _ethFundManager;\n', '\n', '        // transfer tokens to core team\n', '        uint256 tokensPerMember = CORE_TEAM_TOKENS / coreTeam.length;\n', '\n', '        for(uint8 i = 0; i < coreTeam.length; i++) {\n', '            transferInternal(this, coreTeam[i], tokensPerMember);\n', '        }\n', '\n', '        // Advisory board fund\n', '        transferInternal(this, advisoryBoardFundManager, ADVISORY_BOARD_TOKENS);\n', '\n', '        // Opensource fund\n', '        transferInternal(this, opensourceFundManager, OPENSOURCE_TOKENS);\n', '\n', '        // Reserve fund\n', '        transferInternal(this, reserveFundManager, RESERVE_TOKENS);\n', '\n', '        // Bounty fund\n', '        transferInternal(this, bountyFundManager, BOUNTY_TOKENS);\n', '    }\n', '\n', '    function buyFor(address _user, uint256 ethers, uint time) internal returns (bool success) {\n', '        require(ethers > 0);\n', '\n', '        uint8 icoStep = getIcoStep(time);\n', '\n', '        require(icoStep == 1 || icoStep == 2);\n', '\n', '        // maximum collected amount for preico is 5000 ether\n', '        if(icoStep == 1 && (totalSoldSlogns + ethers) > 5000 ether) {\n', '            throw;\n', '        }\n', '\n', '        uint256 slognAmount = ethers; // calculates the amount\n', '\n', '        uint256 bonus = calculateBonus(icoStep, totalSoldSlogns, slognAmount);\n', '\n', '        // check for available slogns\n', '        require(balanceOf[this] >= slognAmount + bonus);\n', '\n', '        if(bonus > 0) {\n', '            BonusEarned(_user, bonus);\n', '        }\n', '\n', '        transferInternal(this, _user, slognAmount + bonus);\n', '\n', '        totalSoldSlogns += slognAmount;\n', '\n', '        if(icoStep == 1) {\n', '            preIcoEthers[_user] += ethers;      // fill ethereum used for refund if goal not reached\n', '        }\n', '        if(icoStep == 2) {\n', '            icoEthers[_user] += ethers;      // fill ethereum used for refund if goal not reached\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Buy Slogn tokens\n', '     */\n', '    function buy() payable {\n', '        buyFor(msg.sender, msg.value, block.timestamp);\n', '    }\n', '\n', '    /**\n', '     * Manage ethereum balance\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transferEther(address to, uint256 value) returns (bool success) {\n', '        if(msg.sender != ethFundManager) {\n', '            return false;\n', '        }\n', '\n', '        if(totalSoldSlogns < MIN_PRE_ICO_SLOGN_COLLECTED) {\n', '            return false;\n', '        }\n', '\n', '        if(this.balance < value) {\n', '            return false;\n', '        }\n', '\n', '        to.transfer(value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if(isTransactionsAllowed == false) {\n', '            if(msg.sender != bountyFundManager) {\n', '                return false;\n', '            }\n', '        }\n', '\n', '        return transferInternal(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if(isTransactionsAllowed == false) {\n', '            if(_from != bountyFundManager) {\n', '                return false;\n', '            }\n', '        }\n', '\n', '        return transferFromInternal(_from, _to, _value);\n', '    }\n', '\n', '    function refund() returns (bool) {\n', '        return refundInternal(block.timestamp);\n', '    }\n', '\n', '    function icoFinish() returns (bool) {\n', '        return icoFinishInternal(block.timestamp);\n', '    }\n', '\n', '    function setPreIcoDates(uint256 since, uint256 till) onlyOwner {\n', '        PRE_ICO_SINCE = since;\n', '        PRE_ICO_TILL = till;\n', '    }\n', '\n', '    function setIcoDates(uint256 since, uint256 till) onlyOwner {\n', '        ICO_SINCE = since;\n', '        ICO_TILL = till;\n', '    }\n', '\n', '    function setTransactionsAllowed(bool enabled) onlyOwner {\n', '        isTransactionsAllowed = enabled;\n', '    }\n', '\n', '    function () payable {\n', '        throw;\n', '    }\n', '}']